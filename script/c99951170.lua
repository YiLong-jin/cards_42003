--巡此苦旅，以达星辰
local s, id = GetID()

function s.initial_effect(c) 
	-- 效果①：除外灵摆卡并特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_PZONE,LOCATION_PZONE,nil,TYPE_PENDULUM)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 除外双方场上灵摆区域的卡
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_PZONE,LOCATION_PZONE,nil,TYPE_PENDULUM)
	if #g==0 then return end
	
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if ct>0 then
			-- 从墓地·除外状态特殊召唤未来战怪兽
			local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
			if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.BreakEffect()
				local ft=math.min(ct,Duel.GetLocationCount(tp,LOCATION_MZONE))
				if ft>0 then
					if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local ssg=sg:Select(tp,ft,ft,nil)
					for sc in aux.Next(ssg) do
						Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
			end
		end
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end