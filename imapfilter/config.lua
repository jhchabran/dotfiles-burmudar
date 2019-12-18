options.create = true
options.subscribe = true
options.expunge = true

email_pass = os.getenv("ORACLE_MAIL_PASS")

print("Connecting to Oracle Mail ...")

oracle = IMAP {
    server = "stbeehive.oracle.com",
    username = "william.bezuidenhout@oracle.com",
    password = email_pass,
    ssl = "auto"
}

print("Connected to Oracle Mail")

mail = oracle.INBOX



rules = {
    {name = "Spam", read = true, filter = function(m) return m:contain_from("ocic_cicd_notify_ww@oracle.com") + m:contain_from("smayer_org_ww@oracle.com") end, action = function(r) return r:delete_messages() end},
    {name = "OoO", read = true, filter = function(m) return m:contain_subject("OoO") + m:contain_subject("WFH") end, action = function(r) return r:move_messages(oracle['OoO']) end},
    {name = "Admin/Expenses", read= false, filter = function(m) return m:contain_subject("Expense Report") end, action = function(r) return r:move_messages(oracle["Admin/Expenses"]) end},
    {name = "Admin/Amex", read= false, filter = function(m) return m:contain_subject("American Express") end, action = function(r) return r:move_messages(oracle["Admin/Amex"]) end},
    {name = "Admin/Payslips", read= false, filter = function(m) return m:contain_from("vipinfo@infoslips.com") end, action = function(r) return r:move_messages(oracle["Admin/Payslips"]) end},
    {name = "Oracle Group", read= true, filter = function(m) return m:contain_from("Win-Wire_ww@oracle.com") + m:contain_from("oracle_za_grp") end, action = function(r) return r:move_messages(oracle["Oracle Group"]) end},
    {name = "OCI/Communications", read= false, filter = function(m) return m:contain_from("oci-communications_ww@oracle.com") end, action = function(r) return r:move_messages(oracle["OCI/Communications"]) end},
    {name = "OCI JIRA", read = false, filter = function(m) return m:contain_from("jirasd") + m:contain_from("JIRA") + m:contain_from("OPC-INBOUND-NOTIFIER") end, action = function(r) r:move_messages(oracle["OCI/JIRA"]) end},
    {name = "OCI Bitbucket", read = false, filter = function(m) return m:contain_from("OCI Bitbucket") end, action = function(r) r:move_messages(oracle["OCI/Bitbucket"]) end},
    {name = "Archive 60+", read = false, filter = function(m) return m:is_older(60) end, action = function(r) r:move_messages(oracle["Archive"]) end},
    {name = "Clean up OCI", read = false, filter = function(m) return oracle["OCI/JIRA"]:is_older(14) + oracle["OCI/Bitbucket"]:is_older(14) end, action = function(r) r:delete_messages() end},
    {name = "Clean OoO", read = false, filter = function(m) return oracle['OoO']:is_older(3) end, action = function(r) return r:delete_messages() end},
    {name = "Clean Communications", read = false, filter = function(m) return oracle["OCI/Communications"]:is_older(14) end, action = function(r) r:delete_messages() end},
    {name = "Clean up Archive", read = false, filter = function(m) return oracle["Archive"]:is_older(180) end, action = function(r) r:delete_messages() end}
}

function printBlock(c, msg)
    line = ''
    for i = 1, (6 + 2 + #msg) do
        line = line .. c
    end
    fill = c .. c .. c
    print(line)
    print(fill .. ' ' .. msg .. ' ' .. fill)
    print(line)
end

function applyRule(mail, rule)
    print('--- ' .. rule.name .. ' ---')
    result = rule.filter(mail)
    if rule.read then
        print (#result .. " messages marked as read")
        result:mark_seen()
    end
    print(#result .. ' matched messages' )
    if #result > 0 then rule.action(result) end
end

while true do
    for i = 1, #rules do
        applyRule(mail, rules[i])
    end
    printBlock(".", "Waiting for messages")
    mail:enter_idle()
end
