local ok, nomodoro = lk.require("nomodoro")
if not ok then
  return
end

nomodoro.setup({
  work_time = 25,
  break_time = 5,
  menu_available = true,
  texts = {
    on_break_complete = "TIME IS UP!",
    on_work_complete = "TIME IS UP!",
    status_icon = "羽",
    timer_format = "!%0M:%0S", -- To include hours: '!%0H:%0M:%0S'
  },
})
