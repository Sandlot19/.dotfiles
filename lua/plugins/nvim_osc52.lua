return {
    'ojroques/nvim-osc52',
    config = function()
        require('osc52').setup({
            trim = true,
        })
    end
}
