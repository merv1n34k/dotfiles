-- THIS FILE IS MERELY A PLAYGROUND!!! --

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local function fn(
  args,     -- text from i(2) in this example i.e. { { "456" } }
  parent,   -- parent snippet or parent node
  user_args -- user_args from opts.user_args
)
    local _,wc = args[1][1]:gsub("%S+","")
        local test = {"", "You have typed " .. wc .. " words!"}
    return test
end

return {
    s("trig",
    {
        t({
            [=[\begin{figure}]=],
            "",
        }),
        i(1,"Figure source"),
        t({"",[=[\Caption{]=]}),
        i(2, "", {key = "i2"}),
        f(fn, {k("i2")},{}),
        t( {"}", [=[\end{figure}]=]})

}),
    s("md",
    {
        t({[[\begin{markdown}]], ""}),
        i(1),
        t({"",[[\end{markdown}]],""}),
        i(0),
}),
    s("md2",
    {
        t({[[\twocol{\begin{markdown}]], ""}),
        i(1),
        t({"",[[\end{markdown}}]],""}),
        i(0),
}),


    s("trigger", {
	t({"After expanding, the cursor is here ->"}), i(1),
	t({"", "After jumping forward once, cursor is here ->"}), i(2),
	t({"", "After jumping once more, the snippet is exited there ->"}), i(0),
}),
    s("tmptt",
        {
            t({
                [=[\documentclass{minimal}]=],
                [=[\usepackage{caption}]=],
                [=[\begin{document}]=],
	            [=[Ed eddy AFC eye fife. Try to be spic. This is a test!]=],
                "",
                [=[\[]=],
                [=[x^2 = \vec{x} = 35 ]=]}),
            i(1),
            i(2),
            t({
                "",
                [=[\]]=],
                "",
                [=[Hey mayday! How are you Doing?]=],
                [=[lorem ipsum]=],
                [=[\end{document}]=]})
        }
    ),
-- redo!!!! try to implement 'smart' snippets using lua only with DyncamicNode
    s("figtd",
        {
            t([=[\begin{figure}]=]),
            i(1),
            d(2, function(args)
                _,wc = args:gsub("%S+","")
                if wc >= 3 then
                    test = 100
                end
                return sn(nil,{i(1,test)})
                end,
            {1})
        }
    )
}
