
  do ->

    primary-key = -> "#it INTEGER PRIMARY KEY AUTOINCREMENT"

    foreign-key = -> "#it INTEGER NOT NULL"

    attribute = ({ name, type, not-null }) -> "#name #type #{ if not-null then 'NOT NULL' else '' }"

    unique-constraint = (fields) -> "UNIQUE ( #{ fields.join ', ' } )"

    line = -> "\n  #it"

    #

    entity-as-sql-lines = (entity) ->

      attributes = []

      sql = []

      sql.push "CREATE TABLE #{ entity.name } ("

      if entity.pk isnt void
        attributes.push line primary-key entity.pk

      for fk in entity.fk
        attributes.push line foreign-key fk

      for attr in entity.attributes
        attributes.push line attribute attr

      for unique in entity.unique
        attributes.push line unique-constraint unique

      sql.push attributes.join ", "

      sql.push ''

      sql.push ");"

      sql.push ''

      sql

    generate-sql = (entities) ->

      sql-lines = []

      for entity in entities

        sql-lines = sql-lines ++ entity-as-sql-lines entity

      sql-lines

    {
      generate-sql
    }