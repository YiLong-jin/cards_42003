--新序系13 以太阿蒙
function c17032490.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c17032490.splimit)
	c:RegisterEffect(e1)
	--mat
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17032490,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c17032490.mattg)
	e2:SetOperation(c17032490.matop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--mat
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17032490,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c17032490.xyzmattg)
	e5:SetOperation(c17032490.xyzmatop)
	c:RegisterEffect(e5)
end
c17032490.New_Order=13
function c17032490.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return se:GetHandler():IsSetCard(0x95) and sc:IsType(TYPE_SPELL)
end
function c17032490.cfilter(c,tp,rk)
	local rank=c:GetRank()
	local ct=0
	if rank>rk then ct=rank-rk else ct=rk-rank end
	return c:IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct
end
function c17032490.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rk=e:GetHandler():GetRank()
	if chk==0 then return Duel.IsExistingMatchingCard(c17032490.cfilter,tp,0,LOCATION_MZONE,1,nil,tp,rk) end
end
function c17032490.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rk=c:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17032490,1))
	local g=Duel.SelectMatchingCard(tp,c17032490.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,rk)
	local tc=g:GetFirst()
	local rank=tc:GetRank()
	local ct=0
	if rank>rk then ct=rank-rk else ct=rk-rank end
	local mg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Overlay(c,mg)
end
function c17032490.cfilter2(c,tp,rk)
	local rank=c:GetRank()
	local ct=0
	if rank>rk then ct=rank-rk else ct=rk-rank end
	return c:IsType(TYPE_XYZ) and c:IsControler(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct
end
function c17032490.xyzmattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rk=e:GetHandler():GetRank()
	if chk==0 then return eg:IsExists(c17032490.cfilter2,1,nil,tp,rk) end
end
function c17032490.xyzmatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local g=eg:Filter(c17032490.cfilter2,nil,tp,rk)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17032490,1))
	tc=g:Select(tp,1,1,nil):GetFirst()
	local rank=tc:GetRank()
	local ct=0
	if rank>rk then ct=rank-rk else ct=rk-rank end
	local mg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Overlay(c,mg)
end