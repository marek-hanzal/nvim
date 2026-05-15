local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	s(
		"component",
		fmt(
			[[
import { type FC } from "react";

export namespace #$ {
    export interface Props {
        #$
    }
}

export const #$: FC<#$.Props> = ({
    #$
}) => {
    return (
        #$
    )
}
        ]],
			{
				i(1, "Foo"),
				i(2, "props"),
				rep(1),
				rep(1),
				i(3, "props"),
				i(0),
			},
			{
				delimiters = "#$",
			}
		)
	),
}
