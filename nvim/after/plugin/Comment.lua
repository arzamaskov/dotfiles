local ts_comment_integration = require("ts_context_commentstring.integrations.comment_nvim")
local file_types = require("Comment.ft")

require("Comment").setup({
	pre_hook = ts_comment_integration.create_pre_hook(),
})

-- Set custom comment strings
file_types.set("smarty", "{* %s *}")
