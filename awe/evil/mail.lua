-------------------------------------------------------------------------------
-- Evil Mail Monitoring                                                      --
-------------------------------------------------------------------------------
-- Provides:                                                                 --
--   evil::mail_ims   : Check my mails (IMS Account)                         --
--   evil::mail_main  : Check my mails (Main Account)                        --
-------------------------------------------------------------------------------
local awful = require("awful")

local cmd_mail_ims = [[ bash -c "~/Sync/Rice/_private/checkmail-ims.sh" ]]
local cmd_mail = [[ bash -c "~/Sync/Rice/_private/checkmail-uni.sh" ]]
local interval = 314

awful.widget.watch(cmd_mail, interval, function(_, evil)
	local count = tonumber(evil)
	if count and count > 0 then
		awesome.emit_signal("evil::mail_main", " New Mail ")
	else
		awesome.emit_signal("evil::mail_main", "nop")
	end
end)

awful.widget.watch(cmd_mail_ims, interval, function(_, evil)
	local count = tonumber(evil)
	if count and count > 0 then
		awesome.emit_signal("evil::mail_ims", " New E-Mail (IMS) ")
	else
		awesome.emit_signal("evil::mail_ims", "nop")
	end
end)
