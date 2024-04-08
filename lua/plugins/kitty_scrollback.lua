return {
    'mikesmithgh/kitty-scrollback.nvim',
    branch = 'main',
    config = function()
        require('kitty-scrollback').setup()
    end
}
