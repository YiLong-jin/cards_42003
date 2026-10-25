--于下一次夏日再见吧
local cm,m=GetID()

--内置字段「魔法少女的夏日」
--get c.Magia_Summer_Vacation
cm.Magia_Summer_Vacation=true

function cm.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918,9877907)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end

cm.fusion_effect=true
function cm.tgsfilter(c,code)
	return c:IsFaceup() and aux.IsCodeListed(c,code)
end

function cm.tgsfilter2g(c,g)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSynchroSummonable(nil,g,#g-1,#g-1)
end

function cm.tgsfilter2(g)
	return g:IsExists(Card.IsCode,1,nil,9877873) and Duel.IsExistingMatchingCard(cm.tgsfilter2g,tp,0x40,0,1,nil,g)
end

function cm.tgsfilter3(c)
	return aux.IsCodeListed(c,9877918) and c:IsAbleToHand()
end

function cm.filter40(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end

function cm.filter41(c,e)
	return cm.filter40(c) and not c:IsImmuneToEffect(e)
end

function cm.tgsfilter4(c,e,tp,mg,f,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsCodeListed(c,9877907) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end

function cm.tgckfilter(n)
	if type(n)=="boolean" then
		if n then return 1 else return 0 end
	else
		if n==1 then return true else return false end
	end
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ck1=Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,9877873)
	local ck2=Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,9877918)
	local ck3=Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,9877907)
	if chk==0 then
		local g=Duel.GetSynchroMaterial(tp)
		local b1=ck1 and g and g:CheckSubGroup(cm.tgsfilter2,1,#g)
		local b2=ck2 and Duel.IsExistingMatchingCard(cm.tgsfilter3,tp,0x01,0,1,nil)
		local chkf=tp
		local res=Duel.IsExistingMatchingCard(cm.tgsfilter4,tp,0x40,0,1,nil,e,tp,Duel.GetMatchingGroup(cm.filter40,tp,0x0e,0,nil),nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.tgsfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		local b3=ck3 and res
		e:SetLabel(cm.tgckfilter(b1),cm.tgckfilter(b2),cm.tgckfilter(b3))
		return b1 or b2 or b3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local n1,n2,n3=e:GetLabel()
	local g=Duel.GetSynchroMaterial(tp)
	local b1=cm.tgckfilter(n1) and g and g:CheckSubGroup(cm.tgsfilter2,1,#g)
	local b2=cm.tgckfilter(n2) and Duel.IsExistingMatchingCard(cm.tgsfilter3,tp,0x01,0,1,nil)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.filter41,tp,0x0e,0,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.tgsfilter4,tp,0x40,0,nil,e,tp,mg1,nil,chkf)
	local res=#sg1>0
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.tgsfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	local b3=cm.tgckfilter(n3) and res
	if b1 or b2 or b3 then
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)},{b3,aux.Stringid(m,2)})
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			g=g:SelectSubGroup(tp,cm.tgsfilter2,false,1,#g)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=Duel.SelectMatchingCard(tp,cm.tgsfilter2g,tp,0x40,0,1,1,nil,g):GetFirst()
				if tc then
					Duel.SynchroSummon(tp,tc,nil,g,#g-1,#g-1)
				end
			end
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local hg=Duel.SelectMatchingCard(tp,cm.tgsfilter3,tp,0x01,0,1,1,nil)
			if #hg>0 then
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		elseif op==3 then
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(cm.tgsfilter4,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
			end
			if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
					tc:SetMaterial(mat1)
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
			end
		end
	end
end