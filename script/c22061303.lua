--青眼的少女
function c22061303.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c22061303.spcon)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22222144,0))
	--e3:SetCategory(CATEGORY_)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,22222144)
	--e3:SetTarget(c2102065.atktg1)
	e3:SetOperation(c22061303.activate)
	c:RegisterEffect(e3)

	if not c22061303.global_check then
		c22061303.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetCountLimit(1,22222144+EFFECT_COUNT_CODE_DUEL)
		ge1:SetOperation(c22061303.count)
		Duel.RegisterEffect(ge1,0)
		
	end
end
function c22061303.count(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do 
	local lps=Duel.GetLP(p)/1000
	local hp1=Duel.GetFlagEffect(p,22222144)
	if hp1==0 then 
	local tc=0
	while (tc<lps) do
		Duel.RegisterFlagEffect(p,22222144,0,0,1)
		lps=lps-1
	end
	end	
	end
end
function c22061303.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return g:GetCount()>=8 and g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c22061303.activate(e,tp,eg,ep,ev,re,r,rp)
	local hp2=Duel.GetFlagEffect(tp,22222144)*1000
	Duel.SetLP(tp,hp2)
	--Duel.SetLP(1-tp,0)
end
