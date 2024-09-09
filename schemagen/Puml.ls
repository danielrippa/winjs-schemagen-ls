
  do ->

    entity-as-lines = (entity) ->

      lines = []

      if entity.pk isnt void
        lines.push "  * #{ entity.pk }"

      lines.push '--'

      for fk in entity.fk
        lines.push "  * #fk"

      lines.push '--'

      for attribute in entity.attributes
        lines.push "  #{ if attribute.not-null then '* ' else '' }#{ attribute.name }"

      [ "entity #{ entity.name } {" ] ++ lines ++ [ "}" ]

    #

    generate-puml = (entities, relationships-lines) ->

      entity-lines = []

      for entity in entities

        entity-lines = entity-lines ++ entity-as-lines entity

      <[ @startuml ]> ++ entity-lines ++ relationships-lines ++ <[ @enduml ]>

    {
      generate-puml
    }