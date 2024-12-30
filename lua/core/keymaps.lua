local keymap = vim.keymap.set

-- Window management
vim.keymap.set('n', '<leader>w', '<C-w>', { desc = 'Window commands' })

-- Telescope
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
