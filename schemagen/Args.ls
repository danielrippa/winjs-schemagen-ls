
  do ->

    { args, argc } = dependency 'prelude.Args'
    { errln } = dependency 'prelude.IO'
    { lower-case, starts-with, drop-first-chars, trimmed-is-empty } = dependency 'native.String'
    { file-exists, read-text-file } = dependency 'prelude.FileSystem'
    { text-as-lines } = dependency 'primitive.Text'
    { drop-first-items, reject-items } = dependency 'native.Array'

    actions = <[ sql puml ]>

    [ sql, puml ] = actions

    usage = ->

      * "Usage:"
        ""
        "#{ args.0 } sql|puml @files|filepath ..."

      |> (* '\n')
      |> errln

    #

    if argc < 3 =>

      usage!

      errorlevel = 1

    else

      action = lower-case args.1

      if not action in actions

        usage!

        error-level 1

      else

        filepath = args.2

        if filepath `starts-with` '@'

          filepath = filepath `drop-first-chars` 1

          if not file-exists filepath

            * "Unable to read FileList file '#filepath'."
              "Error: File '#filepath' not found."

            |> (* '\n')
            |> errln

            error-level = 2

          else

            filepaths = read-text-file filepath |> text-as-lines

            filepaths = filepaths `reject-items` trimmed-is-empty

        else

          filepaths = [ filepath ]

    if errorlevel is void

      if filepaths is void

        filepaths = args `drop-first-items` 1

    {
      sql, puml, action,
      errorlevel, filepaths
    }