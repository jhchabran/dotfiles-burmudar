options.create = true
options.subscribe = true
options.expunge = true

print("Connecting to Oracle Mail")

oracle = IMAP {
    server = "stbeehive.oracle.com",
    username = "william.bezuidenhout@oracle.com",
    password = "***REMOVED***",
    ssl = "auto"
}

print("Connected to Oracle Mail")

mail = oracle.INBOX



rules = {
    {name = "spam", filter = function(m) return m:contain_from("ocic_cicd_notify_ww@oracle.com") end, action = function(r) return r:delete_messages() end},
    {name = "OoO", filter = function(m) return m:contain_subject("OoO") + m:contain_subject("WFH") end, action = function(r) return r:move_messages(oracle['OoO']) end},
    {name = "Clean OoO", filter = function(m) return oracle['OoO']:is_older(7) end, action = function(r) return r:delete_messages() end}
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
    print(#result .. ' matched messages' )
    if #result > 0 then rule.action(result) end
end

repeat
    for i = 1, #rules do
        applyRule(mail, rules[i])
    end
    printBlock(".", "Waiting for messages")
until mail:enter_idle()
