return {
    {
        'aklt/plantuml-syntax',
    },
    {
        'https://gitlab.com/itaranto/plantuml.nvim',
        config = function()
            require('plantuml').setup()
        end
    }
}
