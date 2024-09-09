
  { errorlevel, filepaths, puml, sql, action } = dependency 'schemagen.Args'

  { parse-models } = dependency 'schemagen.Models'
  { generate-sql } = dependency 'schemagen.Sql'
  { generate-puml } = dependency 'schemagen.Puml'

  { outln, errln } = dependency 'prelude.IO'

  if errorlevel is void

    try

      [ entities, relationships ] = parse-models filepaths

      lines = switch action

        | sql => generate-sql entities
        | puml => generate-puml entities, relationships

      for line in lines => outln line

    catch

      errln e.message

      errorlevel = 1

