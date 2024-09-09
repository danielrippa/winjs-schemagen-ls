
  do ->

    { upper-case, string-as-words, drop-last-chars, trim } = dependency 'native.String'
    { text-as-lines } = dependency 'primitive.Text'
    { file-exists, read-text-file } = dependency 'prelude.FileSystem'
    { drop-first-items } = dependency 'native.Array'

    model-error = (filepath, line, line-index, message) ->

      throw new Error do

        * "Error in Model file '#filepath', at line ##{ line-index }."
          "Line: '#line'"
          message

        |> (* '\n')

    #

    attribute-from-words = (words, line, index) ->

      type = switch words.0

        | 'S' => 'TEXT'
        | 'N' => 'INTEGER'
        | 'F' => 'REAL'
        | 'B' => 'BLOB'

        | 'TS' => 'DATETIME DEFAULT current_timestamp'

      return if type is void

      name = words.1

      not-null = (name.index-of '!') isnt -1

      if not-null

        name = name `drop-last-chars` 1

      { name, type, not-null }

    #

    new-entity = (name) -> { name, pk: void, unique: [], fk: [], attributes: [] }

    #

    parse-model = (filepath) ->

      entities = [] ; relationships = []

      entity = void

      for line, index in text-as-lines read-text-file filepath

        words = string-as-words trim line

        continue if words.length is 0

        keyword = upper-case words.0

        switch keyword

          | '*' =>

            model-error filepath, line, index, "Entities must specify a name (e.g. '* EntityName')" \
              if words.length < 2

            entities.push entity \
              if entity isnt void

            name = words.1

            entity = new-entity (name)

          | 'PK' =>

            model-error filepath, line, index, "Primary Keys must specify a name (e.g. 'PK PrimaryKeyName')" \
              if words.length < 2

            name = words.1

            model-error filepath, line, index, "Entity already has PK #{ entity.pk }" \
              if entity.pk isnt void

            entity.pk = name

          | 'FK' =>

            model-error filepath, line, index, "Foreign keys must specify both a Name and a Field reference (e.g. 'FK ForeignName EntityName.FieldName')" \
              if words.length < 3

            name = words.1
            field = words.2

            model-error filepath, line, index, "Foreign key Field references must be specified as EntityName.FieldName" \
              if (field.index-of '.') is -1

            [ foreign-entity-name, foreign-field-name ] = field.split '.'

            entity.fk.push name

            relationships.push "#{ entity.name }::#{ name } -- #foreign-entity-name::#foreign-field-name"

          | 'U' =>

            model-error filepath, line, index, "Unique constraints must specify a list of fields (e.g. 'U FieldName1 FieldName2')" \
              if words.length < 1

            field-names = words `drop-first-items` 1

            entity.unique.push field-names

          | 'S', 'N', 'F', 'B', 'TS' =>

            model-error filepath, line, index, "Attributes must specify a Name (e.g. #that AttributeName)" \
              if words.length < 2

            attribute = attribute-from-words words

            model-error filepath, line, index "Invalid attribute type '#{ words.0 }'" \
              if attribute is void

            entity.attributes.push attribute

          else

            model-error filepath, line, index, "Invalid statement '#line'"

      entity = void

      [ entities, relationships ]

    #

    parse-models = (filepaths) ->

      entities = [] ; relationships = []

      for filepath in filepaths

        [ model-entities, model-relationships ] = parse-model filepath

        entities = entities ++ model-entities
        relationships = relationships ++ model-relationships

      [ entities, relationships ]

    {
      parse-models
    }