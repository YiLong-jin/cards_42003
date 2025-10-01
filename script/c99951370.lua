--俄罗斯娃娃
function c99951370.initial_effect(c)
--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99951370+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c99951370.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,99951371)
	e2:SetTarget(c99951370.tdtg)
	e2:SetOperation(c99951370.tdop)
	c:RegisterEffect(e2)

end
function c99951370.filter(c,tp,pcon)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE))
		and c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsType(TYPE_PENDULUM) and pcon) or (c:IsFaceup() and c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c99951370.activate(e,tp,eg,ep,ev,re,r,rp)
	local pcon=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99951370.filter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,tp,pcon)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99951370,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
	local op=0
	local options={}
	
	-- 加入手卡选项
	if sc:IsAbleToHand() then
		table.insert(options,1)
	end
	
	-- 放置灵摆区域选项
	if sc:IsType(TYPE_PENDULUM) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		table.insert(options,2)
	end
	
	-- 特殊召唤选项
	if sc:IsType(TYPE_PENDULUM) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not sc:IsLocation(LOCATION_EXTRA)) or Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		table.insert(options,3)
	end
	
	if #options==0 then return end
	
	-- 构建选项文本
	local opts={}
	local descs={}
	if sc:IsAbleToHand() then
		table.insert(opts,aux.Stringid(99951370,1))
		table.insert(descs,1)
	end
	if sc:IsType(TYPE_PENDULUM) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		table.insert(opts,aux.Stringid(99951370,2))
		table.insert(descs,2)
	end
	if sc:IsType(TYPE_PENDULUM) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not sc:IsLocation(LOCATION_EXTRA)) or Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		table.insert(opts,aux.Stringid(99951370,3))
		table.insert(descs,3)
	end
	
	if #opts==0 then return end
	
	local selection=Duel.SelectOption(tp,table.unpack(opts))
	op=descs[selection+1]
	
	if op==1 then
		-- 加入手卡
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	elseif op==2 then
		-- 放置灵摆区域
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	elseif op==3 then
		-- 特殊召唤
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
--e2
function c99951370.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end

function c99951370.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c99951370.tdfilter,tp,LOCATION_EXTRA,0,nil)
		return g:GetCount()>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,0)
end

function c99951370.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c99951370.tdfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		if sg:GetCount()==2 then
			sg:AddCard(c)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
