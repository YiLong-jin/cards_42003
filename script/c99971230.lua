--驭时巫师

local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x67f),4,5)
	c:EnableReviveLimit()
	-- ①：特殊召唤时发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99971230)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	
		-- spell back
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e4:SetDescription(aux.Stringid(99971230,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,99971231)
	e4:SetCost(c99971230.cost)
	e4:SetTarget(c99971230.target2)
	e4:SetOperation(c99971230.operation2)
	c:RegisterEffect(e4)
end




function c99971230.filter2(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToHand() and c:IsSetCard(0x67f)
end
function c99971230.filter3(c)
	return c:IsSetCard(0x67f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99971230.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99971230.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971230.filter3,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c99971230.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)	
end
function c99971230.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99971230.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c99971230.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			 Duel.SendtoHand(g2,tc,nil,REASON_EFFECT)
		end
	end
end




















function c99971230.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971230))
end
function c99971230.filter1(c,codee)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(codee)
end
function s.thfilter(c)
	return c:IsSetCard(0x67f) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
		and c:IsAbleToHand() and c:IsFaceup()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x67f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查墓地或除外区是否有「超凡世界」卡可以加入手卡
		local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #thg==0 then return false end
		
		-- 检查墓地是否有3只「超凡世界」怪兽可以特殊召唤
		local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		local zone=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if zone>0 then
			if zone>3 then zone=3 end
			return #spg>=zone
		else
			return false
		end
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971230.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local codee=tc:GetCode()
	local flag=5
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971230.filter1,tp,0x3f,0x3f,1,nil,codee) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
	-- 效果1：把墓地·除外1张「超凡世界」卡加入手卡
	local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #thg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thc=thg:Select(tp,1,1,nil):GetFirst()
		if thc then
			Duel.SendtoHand(thc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thc)
		end
	end
	
	-- 效果2：选自己墓地3只「超凡世界」怪兽特殊召唤
	local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local zone=Duel.GetLocationCount(tp,LOCATION_MZONE)
	
	if #spg>0 and zone>0 then
		local ct=math.min(3,zone)
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spc=spg:Select(tp,ct,ct,nil)
			if #spc>0 then
				-- 批量特殊召唤
				for tc in aux.Next(spc) do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end