return {
	s("trig", t("loaded!!")),

    s("trig3", {
	t"text: ", i(1), t{"", "copy: "},
	d(2, function(args)
			-- the returned snippetNode doesn't need a position; it's inserted
			-- "inside" the dynamicNode.
			return sn(nil, {
				-- jump-indices are local to each snippetNode, so restart at 1.
				i(1, args[1])
			})
		end,
	{1})
})
}
