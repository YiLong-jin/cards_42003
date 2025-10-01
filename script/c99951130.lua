--克隆 城堡
local s, id = GetID()

-- 字段定义


function s.initial_effect(c)
	-- Link怪兽设定
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c99951130.mfilter,1,1) 

	
	-- 效果①：特殊召唤墓地克隆怪兽并拉同名卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function c99951130.mfilter(c)
	return  c:IsLinkType(TYPE_XYZ) and c:IsSetCard(0x674) and c:IsRankAbove(5)
end
-- 效果①：特殊召唤
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x674) and c:IsType(TYPE_XYZ) and c:GetRank()<=4
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g==0 then return end
	
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		-- 从额外卡组特殊召唤同名卡
		local code=tc:GetCode()
		local sg=Duel.GetMatchingGroup(s.extrafilter,tp,LOCATION_EXTRA,0,nil,code,e,tp)
		if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),#sg)
			if ft>0 then
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local esg=sg:Select(tp,ft,ft,nil)
				for ec in aux.Next(esg) do
					Duel.SpecialSummonStep(ec,0,tp,tp,false,false,POS_FACEUP)
					-- 效果无效化
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					ec:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					ec:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetRange(LOCATION_MZONE)
			e3:SetAbsoluteRange(tp,1,0)
			e3:SetTarget(s.splimit)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e3,true)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end

function s.extrafilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.splimit(e,c)
	return not c:IsSetCard(0x671)
end