return {
  -- LaTeX command mappings (no LazyVim dependency)
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      -- Create an autocmd group for LaTeX commands
      local augroup = vim.api.nvim_create_augroup("latex_commands", { clear = true })
      
      -- Add LaTeX file type detection
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "tex",
        callback = function()
          -- Helper function to run command and capture output
          local function run_latex_cmd(cmd, success_msg, error_msg)
            vim.cmd("write") -- Save the file first
            
            -- Create a new buffer for output
            local buf = vim.api.nvim_create_buf(false, true)
            local win = vim.api.nvim_open_win(buf, true, {
              relative = 'editor',
              width = math.floor(vim.o.columns * 0.8),
              height = math.floor(vim.o.lines * 0.8),
              row = math.floor(vim.o.lines * 0.1),
              col = math.floor(vim.o.columns * 0.1),
              style = 'minimal',
              border = 'rounded',
              title = ' LaTeX Output ',
              title_pos = 'center'
            })
            
            -- Set buffer options
            vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
            vim.api.nvim_buf_set_option(buf, 'filetype', 'log')
            
            -- Add initial message
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Running: " .. cmd, "", "Output:"})
            
            -- Setup keymapping to close the window
            vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
            vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
            
            -- Function to auto-scroll to the bottom
            local function scroll_to_bottom()
              local line_count = vim.api.nvim_buf_line_count(buf)
              vim.api.nvim_win_set_cursor(win, {line_count, 0})
            end
            
            -- Run the command
            local job_id = vim.fn.jobstart(cmd, {
              on_stdout = function(_, data)
                if data and #data > 1 or (data[1] and data[1] ~= "") then
                  vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
                    scroll_to_bottom() -- Auto-scroll after adding new lines
                  end)
                end
              end,
              on_stderr = function(_, data)
                if data and #data > 1 or (data[1] and data[1] ~= "") then
                  vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
                    scroll_to_bottom() -- Auto-scroll after adding new lines
                  end)
                end
              end,
              on_exit = function(_, code)
                vim.schedule(function()
                  if code == 0 then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"", "✓ " .. success_msg})
                    vim.notify(success_msg, vim.log.levels.INFO)
                  else
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"", "✗ " .. error_msg .. " (Exit code: " .. code .. ")"})
                    vim.notify(error_msg, vim.log.levels.ERROR)
                  end
                  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"", "Press 'q' or <Esc> to close this window"})
                  scroll_to_bottom() -- Final scroll to see the result
                end)
              end,
            })
            
            return job_id
          end
          
          -- Compile only
          vim.keymap.set("n", "<leader>tc", function()
            run_latex_cmd("latexmk -pdf " .. vim.fn.expand("%"), 
                          "LaTeX compiled successfully", 
                          "LaTeX compilation failed")
          end, { buffer = true, desc = "Compile LaTeX" })

          -- Compile and clean
          vim.keymap.set("n", "<leader>tb", function()
            run_latex_cmd("latexmk -pdf " .. vim.fn.expand("%") .. " && latexmk -c", 
                          "LaTeX compiled and cleaned", 
                          "LaTeX build failed")
          end, { buffer = true, desc = "Compile and clean LaTeX" })

          -- Clean only
          vim.keymap.set("n", "<leader>tx", function()
            run_latex_cmd("latexmk -c", 
                          "LaTeX files cleaned", 
                          "LaTeX cleanup failed")
          end, { buffer = true, desc = "Clean LaTeX files" })
        end,
      })
    end,
  },

  -- Add which-key integration for LaTeX commands
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>t"] = { name = "+tex" },
      },
    },
  },
}
