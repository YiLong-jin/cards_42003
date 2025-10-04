--火金符「圣爱尔摩火柱」
local s,id,o=GetID()
function s.initial_effect(c)

	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(aux.FALSE)
	c:RegisterEffect(e8)
		--attribute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_ATTRIBUTE)
	e7:SetRange(0xff)
	e7:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e7)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCondition(c99960490.condition)
	e1:SetCost(c99960490.spcost)
	e1:SetOperation(c99960490.activate)
	c:RegisterEffect(e1)
	
			--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.gcon)
	e2:SetOperation(s.gop)
	c:RegisterEffect(e2)
	
end
c99960490.Savior_Paqi = true

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(id) and re:GetHandlerPlayer()==tp
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
end




function c99960490.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960320)
	local fb=Duel.GetFlagEffect(tp,99960290)
	local count=fa-2
	if chk==0 then return fa>1 and fb>1 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960320)
	Duel.ResetFlagEffect(tp,99960290)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960320,0,0,0)
		Duel.RegisterFlagEffect(tp,99960290,0,0,0)
		end
end
function c99960490.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c99960490.filter(c)
	return c.Savior_Paqi and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function c99960490.selector(count,tp)
	if count>0 then
		local res=table.pack(c99960490.selector(count-1,tp))
		return Duel.AnnounceLevel(tp,1,5,table.unpack(res)),table.unpack(res)
	end
end

function c99960490.activate(e,tp,eg,ep,ev,re,r,rp)
	local j=1
	if Duel.IsExistingMatchingCard(c99960490.filter,tp,LOCATION_MZONE,0,1,nil) then j=2 end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(c99960490.selector(j,tp))
	e2:SetOperation(c99960490.op)
	Duel.RegisterEffect(e2,tp)
end
function c99960490.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for _,i in pairs(table.pack(e:GetLabel())) do
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,5-i))
		if i==2 then
			g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,6))
		elseif i==4 then
			g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,5))
		end
	end
	Duel.Destroy(g,REASON_EFFECT)
end
