--吾即不可动摇之真理
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_DECK)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	--
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(Card.IsSetCard,1,nil,0x7da) then return end
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x7da) then 
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1,tc:GetOriginalCode()) 
		end
		tc=eg:GetNext()
	end
	for p=0,1 do
		if Duel.GetFlagEffect(p,id-1)==0 then 
			local codes={Duel.GetFlagEffectLabel(p,id)}
			local chks={}
			for k,v in pairs(codes) do
				local flag=true 
				for k1,v1 in pairs(chks) do 
					if v==v1 then 
						flag=false 
						break 
					end
				end
				if flag then 
					table.insert(chks,v)
				end
			end
			if #chks>=10 then 
				Duel.RegisterFlagEffect(p,id-1,RESET_PHASE+PHASE_END,0,1) 
			end
		end
	end
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,id-1)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function s.thf(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetReasonPlayer()~=c:GetControler() and  c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(s.thf,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.ConfirmCards(1-tp,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thf),tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
