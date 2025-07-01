--銃符「3Ⅾ打印机喷枪」
local m=17090010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17090010,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTarget(cm.target)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c,code)
	return c:IsCode(code)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,ac):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,5,5,tc)
	g:AddCard(tc)
	Duel.ConfirmCards(1-tp,g)
	local count=6
	local d=math.floor(g:GetCount()/2)
	while count>0 do
		if Duel.SelectYesNo(tp,aux.Stringid(17090010,2)) then
			local cg=g:RandomSelect(tp,1)
			local tcl=cg:GetFirst()
			Duel.Hint(HINT_CARD,0,tcl:GetCode())
			g:RemoveCard(tcl)
			if tcl:GetCode()~=tc:GetCode() then
				count=count-1 
			else
				Duel.SetLP(tp,Duel.GetLP(tp)-g:GetCount()*500)
				count=0
			end
		else
			d=math.floor(g:GetCount()/2)
			Duel.Draw(1-tp,d,REASON_EFFECT)
			count=0
		end
		if count==0 then return end
		if Duel.SelectYesNo(1-tp,aux.Stringid(17090010,2)) then
			local cg1=g:RandomSelect(1-tp,1)
			local tcb=cg1:GetFirst()
			Duel.Hint(HINT_CARD,0,tcb:GetCode())
			g:RemoveCard(tcb)
			if tcb:GetCode()~=tc:GetCode() then
				count=count-1 
			else 
				Duel.SetLP(1-tp,Duel.GetLP(1-tp)-g:GetCount()*500)
				count=0
			end
		else
			d=math.floor(g:GetCount()/2)
			Duel.Draw(tp,d,REASON_EFFECT)
			count=0
		end
	end
end