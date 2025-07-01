--淡淡忧伤
function c22061308.initial_effect(c)
	--宇宙
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
	e2:SetCondition(c22061308.spcon)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,220613081+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c22061308.target)
	e3:SetOperation(c22061308.activate)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,220613082)
	e4:SetCost(c22061308.spcost)
	e4:SetTarget(c22061308.sptg)
	e4:SetOperation(c22061308.spop)
	c:RegisterEffect(e4)

end

--1效果
function c22061308.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	return g:GetCount()>=2 and g:GetClassCount(Card.GetCode)==g:GetCount()
end

function c22061308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return h1>1 and h2>1 and Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function c22061308.activate(e,tp,eg,ep,ev,re,r,rp)
	
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Draw(1-tp,2,REASON_EFFECT)
	
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if h1<2 or h2<2 then return end
	local turnp=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(turnp,aux.TRUE,turnp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-turnp,g1)
	Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-turnp,aux.TRUE,1-turnp,LOCATION_HAND,0,2,2,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	local g9=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,0,2,nil)
	Duel.SendtoDeck(g9,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

function c22061308.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,2,2,REASON_COST)
end
function c22061308.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22061308.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		
		c:RegisterEffect(e1,true)
	end
end




