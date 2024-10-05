local dein_snip = vim.fn.fnamemodify('~/.cache/dein/repos/github.com/ryota2357/dein-snip.lua', ':p')
if not string.match(vim.o.runtimepath, '/dein-snip.lua') then
    if vim.fn.isdirectory(dein_snip) == 0 then
	os.execute('git clone https://github.com/ryota2357/dein-snip.lua.git ' .. dein_snip)
    end
    vim.opt.runtimepath:prepend(dein_snip)
end

require('dein-snip').setup {
    load = {
	toml = {
	    { '~/.config/nvim/dein.toml' }
	},
	raw = {
	    { 'vim-jp/vimdoc-ja', { hook_add = 'set helplang=ja,en' } }
	},
	check_install = true
    },
    notification = {
	enable = true,
	time = 3000
    },
    auto_recache = true
}
