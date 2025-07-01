--天斎标枪
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--chk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.disf(c)
	return c:IsDiscardable(REASON_COST+REASON_DISCARD) and c:IsSetCard(0x7dc)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable(REASON_COST+REASON_DISCARD) and Duel.IsExistingMatchingCard(cm.disf,tp,LOCATION_HAND,0,1,c) end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.DiscardHand(tp,Card.IsSetCard,1,1,REASON_COST+REASON_DISCARD,c,0x7dc)
end
--检测自己场上没有卡存在的纵列的主要区域，返回那个2进制编码
function cm.desfc(tp)
	local filter=0
	for i=0,4 do
		if (not Duel.GetFieldCard(tp,LOCATION_SZONE,i)) and (not Duel.GetFieldCard(tp,LOCATION_MZONE,i)) and (i~=1 or (not Duel.GetFieldCard(tp,LOCATION_MZONE,5))) and (i~=3 or (not Duel.GetFieldCard(tp,LOCATION_MZONE,6))) then 
			filter=filter|1<<i
		end
	end
	return filter 
end
--检测指定序列（0~4），返回值为：二进制的自己区域编码，此区域的所有卡片组
function cm.seqf(tp,seq)
	local filter=0
	local g=Group.CreateGroup()
	for p=0,1 do 
		local pseq=seq 
		if p==1-tp then pseq=4-seq end
		for i=0,1 do
			local tc1=Duel.GetFieldCard(p,(i+1)*LOCATION_MZONE,pseq)
			if tc1 then 
				g:AddCard(tc1)
			elseif p==tp then 
				filter=filter|1<<(seq+i*8)
			end
		end
		if pseq==1 or pseq==3 then 
			local cseq=5
			if pseq==3 then cseq=6 end
			local tc2=Duel.GetFieldCard(p,LOCATION_MZONE,cseq)
			if tc2 then 
				g:AddCard(tc2)
				if tc2:IsControler(tp) then filter=filter|1<<cseq end
			end
		end
	end
	return filter,g
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=cm.desfc(tp)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and seq~=0 end
	local sq=Duel.SelectField(tp,1,LOCATION_MZONE,0,~seq)
	local stq=math.log(sq,2)
	e:SetLabel(stq)
	local zone,g=cm.seqf(tp,stq)
	Duel.Hint(HINT_ZONE,tp,zone)
	if #g>0 then 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	local zone,g=cm.seqf(tp,seq)
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetValue(zone)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp then return end
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if de and dp==tp and de:GetHandler():GetOriginalType()==TYPE_TRAP then
		local ty=re:GetActiveType()
		local flag=c:GetFlagEffectLabel(m)
		if not flag then
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,ty)
			e:SetLabelObject(de)
		elseif de~=e:GetLabelObject() then
			e:SetLabelObject(de)
			c:SetFlagEffectLabel(m,ty)
		else
			c:SetFlagEffectLabel(m,flag|ty)
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=c:GetFlagEffectLabel(m)
	if label~=nil and label~=0 then
		e:SetLabel(label)
		c:SetFlagEffectLabel(m,0)
		return true
	else return false end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
