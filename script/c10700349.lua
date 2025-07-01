--逆転壊獣バトラ
function c10700349.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0xd3),LOCATION_MZONE)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c10700349.lcheck)
	c:EnableReviveLimit()   
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c10700349.matval)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700349,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10700349.descon)
	e2:SetTarget(c10700349.destg)
	e2:SetOperation(c10700349.desop)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e3:SetTargetRange(POS_FACEUP_ATTACK,0)
	e3:SetCondition(c10700349.spcon)
	e3:SetOperation(c10700349.spop)
	c:RegisterEffect(e3)
end
function c10700349.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,c:GetOwner()==tp
end
--get x y label
function c10700349.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
--gradient modification
function c10700349.gradient(y,x)
	if y>0 and x==0 then return 1000 end
	if y<0 and x==0 then return 1100 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+100 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 100 end
	return 65536
end
--draw lines with gradients k
function c10700349.line(tc,c,tp,...)
	local x1,y1=c10700349.xylabel(c,tp)
	local x2,y2=c10700349.xylabel(tc,tp)
	for _,k in ipairs({...}) do
		if c10700349.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
--Link Marker as example
-- ↙ 101
-- ↓ 1100
-- ↘ 99
-- ← 100
-- → 0
-- ↖ -1
-- ↑ 1000
-- ↗ 1
function c10700349.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10700349.desfilter(c,g)
	return g:IsContains(c)
end
function c10700349.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10700349.line,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,1,101,1000)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c10700349.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(g) do
		local x1,y1=c10700349.xylabel(c,tp)
		local x2,y2=c10700349.xylabel(tc,tp)
	end
	local g=Duel.GetMatchingGroup(c10700349.line,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,1,101,1000)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c10700349.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c10700349.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10700349.cfilter,tp,0,LOCATION_MZONE,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700349.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1,true)
end