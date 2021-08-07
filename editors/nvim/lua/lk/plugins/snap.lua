local snap = require 'snap'
local icons = require 'nvim-web-devicons'
require('nvim-web-devicons').setup { default = true }

local fnamemodify = vim.fn.fnamemodify
local get_icon = icons.get_icon
local function add_icon(meta_result)
  local filename = fnamemodify(meta_result.result, ':t:r')
  local extension = fnamemodify(meta_result.result, ':e')
  local icon = get_icon(filename, extension)
  return icon .. ' ' .. meta_result.result
end

local function icons_consumer(producer)
  return function(request)
    for results in snap.consume(producer, request) do
      if type(results) == 'table' then
        if not vim.tbl_islist(results) then
          coroutine.yield(results)
        else
          coroutine.yield(vim.tbl_map(function(result)
            return snap.with_metas(result,
                                   { display = add_icon, highlight_offset = 4 })
          end, results))
        end
      else
        coroutine.yield(nil)
      end
    end
  end
end

snap.register.map('n', '<localleader>sg', snap.create(
                      function()
      return {
        prompt = 'Git Files',
        producer = icons_consumer(snap.get 'consumer.fzy'(
                                      snap.get 'producer.git.file')),
        select = snap.get('select.file').select,
        multiselect = snap.get('select.file').multiselect,
        views = { snap.get 'preview.file' },
      }
    end))

snap.register.map('n', '<localleader>sf', snap.create(
                      function()
      return {
        prompt = 'Files',
        producer = icons_consumer(snap.get 'consumer.fzy'(
                                      snap.get 'producer.fd.file')),
        select = snap.get('select.file').select,
        multiselect = snap.get('select.file').multiselect,
        views = { snap.get 'preview.file' },
      }
    end))

snap.register.map('n', '<localleader>ss', snap.create(
                      function()
      return {
        prompt = 'Rg',
        producer = snap.get 'consumer.limit'(10000,
                                             snap.get 'producer.ripgrep.vimgrep'),
        select = snap.get('select.vimgrep').select,
        multiselect = snap.get('select.vimgrep').multiselect,
        views = { snap.get 'preview.vimgrep' },
      }
    end))

snap.register.map('n', '<localleader>sb', snap.create(
                      function()
      return {
        prompt = 'Buffers',
        producer = icons_consumer(snap.get 'consumer.fzy'(
                                      snap.get 'producer.vim.buffer')),
        select = snap.get('select.file').select,
        multiselect = snap.get('select.file').multiselect,
        views = { snap.get 'preview.file' },
      }
    end))
