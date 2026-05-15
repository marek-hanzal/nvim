local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	s(
		"schema",
		fmt(
			[[
import { z } from "zod";

export const #$Schema = z.looseObject({
	#$
}).strip();

export type #$Schema = typeof #$Schema;

export namespace #$Schema {
	export type Type = z.infer<#$Schema>;
}
]],
			{
				i(1, "Name"),
				i(0),
				rep(1),
				rep(1),
				rep(1),
				rep(1),
			},
			{
				delimiters = "#$",
			}
		)
	),
}
