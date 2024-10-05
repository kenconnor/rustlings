vim.o.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.mouse = ''
vim.cmd[[colorscheme evening]]
vim.g.mapleader = ' '

require('keymap-config')
require('dein-config')
require('coc-config')
require('hop-config')
