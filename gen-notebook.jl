using Literate

mkpath("notebooks")

Literate.notebook("scripts/00.jl", "notebooks", execute=true)
Literate.notebook("scripts/lit-script.jl", "notebooks", execute=true)

# Literate.markdown("scripts/00.jl", "notebooks", execute=true)
# Literate.markdown("scripts/lit-script.jl", "notebooks", execute=true)
