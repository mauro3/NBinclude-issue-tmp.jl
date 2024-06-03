using Literate

mkpath("notebooks")

## Check what happens with @__DIR__ (this throws no error)
Literate.notebook("scripts/lit-script.jl", "notebooks", execute=true)
Literate.markdown("scripts/lit-script.jl", "markdown", execute=true)

## Try to include another file
# first make the included file
Literate.notebook("scripts/00.jl", "notebooks", execute=true)
# now the file which includes 00.jl (this errors)
Literate.notebook("scripts/lit-script-include.jl", "notebooks", execute=true)

## Also errors for markdown:
Literate.markdown("scripts/00.jl", "markdown", execute=true)
Literate.markdown("scripts/lit-script-include.jl", "markdown", execute=true)
