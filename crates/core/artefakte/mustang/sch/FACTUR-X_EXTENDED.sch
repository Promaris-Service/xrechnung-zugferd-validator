<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Factur-X release metadata
     Version: 1.09.2
     Release date: 2026-08-04
     Effective date: 2026-09-01
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="iso">
  <title>Schema for Factur-X; 1.09.2; EN16931-CONFORMANT-EXTENDED</title>
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"/>
  <ns prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"/>
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"/>
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"/>
  <pattern>
    <rule context="//*[not(*) and not(normalize-space())]">
      <assert flag="warning" id="PEPPOL-EN16931-R008" test="false">
	[PEPPOL-EN16931-R008]-Document MUST not contain empty elements. (still status warning)</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:AdditionalReferencedDocument">
      <assert id="BR-52" test="(ram:IssuerAssignedID!='')">
	[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert id="BR-45" test="(ram:BasisAmount)">
	[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</assert>
      <assert id="BR-46" test="(ram:CalculatedAmount)">
	[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</assert>
      <assert id="BR-47" test="(ram:CategoryCode)">
	[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</assert>
      <assert id="BR-48" test="(ram:RateApplicablePercent) or (ram:CategoryCode = 'O')">
	[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</assert>
      <assert id="BR-CO-03" test="((ram:TaxPointDate) and not (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and (ram:DueDateTypeCode)) or (not (ram:TaxPointDate) and not (ram:DueDateTypeCode))">
	[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</assert>
      <assert id="BR-DEC-19" test="string-length(substring-after(ram:BasisAmount,'.'))&lt;=2">
	[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</assert>
      <assert id="BR-DEC-20" test="string-length(substring-after(ram:CalculatedAmount,'.'))&lt;=2">
	[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'Z']">
      <assert id="BR-Z-09" test="../ram:CalculatedAmount = 0">
	[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-AE-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-AE-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reverse charge" (AE), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-AE-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-AE-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reverse charge" (AE), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value ""DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-AE-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'AE' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='AE' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='AE' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-AE-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “AE” ("Reverse charge"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Reverse charge" (AE), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.             </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-E-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-E-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Exempt from VAT" (E), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value ""DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-E-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-E-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Exempt from VAT" (E), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.        </assert>
      <assert flag="warning" id="BR-FXEXT-E-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='E' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='E' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-E-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “E” ("Exempt from VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Exempt from VAT" (E), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-G-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-G-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export  outside  the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Export  outside  the EU" (G), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-G-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-G-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export  outside  the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Export  outside  the EU" (G), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-G-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'G' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='G' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='G' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-G-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “G” ("Export  outside  the EU"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Export  outside  the EU" (G), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-IC-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-IC-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Intra-community supply" (K), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-IC-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-IC-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Intra-community supply" (K), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-IC-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'K' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='K' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='K' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-IC-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “K” ("Intra-community supply"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Intra-community supply" (K), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-AF-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-AF-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Canary Islands tax" (L), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-AF-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-AF-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Canary Islands tax" (L), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-AF-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'L' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='L' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='L' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-AF-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “L” ("Canary Islands tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Canary Islands tax" (L), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-AG-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-AG-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Ceuta and Mellita tax" (M), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-AG-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-AG-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Ceuta and Mellita tax" (M), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-AG-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'M' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='M' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='M' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-AG-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “M” ("Ceuta and Mellita tax"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Ceuta and Mellita tax" (M), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified. </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-O-08b" test="(for
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O' and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='O' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='O' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'O' and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'O'])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='O' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='O'])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O' and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O']/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O' and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O']))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-O-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Not subject to VAT" (O), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-O-08ini" test="(for
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O']/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount)) * 100) div 100),        
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='O']/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'O'])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='O'])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O']/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O']))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-O-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Not subject to VAT" (O), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-O-08rev" test="(for  
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'O' and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='O' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='O' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'O' and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='O' and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O' and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='O' and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-O-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “O” ("Not subject to VAT"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Not subject to VAT" (O) and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S']">
      <assert id="BR-FXEXT-S-09b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $vATAmountBT117 in xs:decimal(ram:CalculatedAmount),
        $calculatedBT117 in xs:decimal(round($basisAmount * $rate div 100 * 100) div 100)
        return 
        (abs($vATAmountBT117 - $calculatedBT117) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($vATAmountBT117 - $calculatedBT117) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-S-09b] - For each different value of VAT rate (BT-119) where the VAT category code (BT-118) is equal to “S” ("Standard rated"), Absolute Value of (VAT  category  tax  amount  (BT-117) - VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119)/100) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level allowance amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is " Standard rated " (S), and the VAT rate (BT-152, BT-96, BT-103, BT-X-274) equals the VAT category rate (BT-119), and only for lines where the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value "DETAIL" or is not specified or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176) and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-S08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or  ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-S08b]-In a VAT breakdown (BG-23), for each different value of VAT rate (BT-119) where VAT category code (BT-118) is equal to “S” ("Standard Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard Rated" (S), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified,  or the same rule but also taking into account the exemption reasons in Text (BT-120) and Code (BT-121) in BG-23 and the exemption reasons on each line (BT-X-96 / BT-X-97), on Document level Allowances  (BT-173 / BT-174) and on Document Level Charges (BT-175 / BT-176), and on Service logistic charges (BT-X-591 / BT-X-592). One of the two rules must be followed, bearing in mind that ultimately only the second one will have to be followed.</assert>
      <assert flag="warning" id="BR-FXEXT-S-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-S-08ini] - In a VAT breakdown (BG-23), for each different value of VAT rate (BT-119), where VAT category code (BT-118) is equal to “S” ("Standard Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard Rated" (S), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert flag="warning" id="BR-FXEXT-S-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'S' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='S' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-S-08rev] - In a VAT breakdown (BG-23), for each different value of VAT rate (BT-119), where VAT category code (BT-118) is equal to “S” ("Standard Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Standard Rated" (S), and where applicable the VAT exemption reason and specification code (BT-195, BT-174 and BT-176 and BT-X-592) and the Exemption reason text (BT-194, BT-173 and BT-175 and BT-X-591) are identical with the VAT category VAT exemption reason and specification code (BT-121) and VAT exemption reason text (BT-120), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'][upper-case(ram:TypeCode) = 'VAT']">
      <assert id="BR-FXEXT-Z-08b" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return 
        (abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge)) or (abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini)))">
	[BR-FXEXT-Z-08b] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.   </assert>
      <assert flag="warning" id="BR-FXEXT-Z-08ini" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate ]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='S' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99ini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItemsini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate])),
        $nbAllowancesOrChargesini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate])),
        $logisticChargeAmountini in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticChargeini in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate]))
        return      
        abs($basisAmount - $calculatedAmountBT131ini + $allowancesAmountBT92ini - $chargesAmountBT99ini - $logisticChargeAmountini) le 0.01 * ($nbLineItemsini + $nbAllowancesOrChargesini + $nblogisticChargeini))">
	[BR-FXEXT-Z-08ini] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z), but only for lines where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified.    </assert>
      <assert flag="warning" id="BR-FXEXT-Z-08rev" test="(for  
        $rate in xs:decimal(ram:RateApplicablePercent),
        $exempReasonText in normalize-space(ram:ExemptionReason),
        $exempReasonCode in normalize-space(ram:ExemptionReasonCode),
        $basisAmount in xs:decimal(ram:BasisAmount),
        $calculatedAmountBT131 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement[ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText]/ram:SpecifiedTradeSettlementLineMonetarySummation/xs:decimal(ram:LineTotalAmount)) * 100) div 100),
        $allowancesAmountBT92 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=false() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $chargesAmountBT99 in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=true() and ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:ActualAmount)) * 100) div 100),
        $nbLineItems in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[(not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL') and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'Z' and ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/xs:decimal(ram:RateApplicablePercent) =$rate and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $nbAllowancesOrCharges in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:CategoryTradeTax/ram:CategoryCode='Z' and ram:CategoryTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate  and normalize-space(ram:CategoryTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:CategoryTradeTax/ram:ExemptionReason) = $exempReasonText])),
        $logisticChargeAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]/xs:decimal(ram:AppliedAmount)) * 100) div 100),
        $nblogisticCharge in xs:decimal(count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge[ram:AppliedTradeTax/ram:CategoryCode='Z' and ram:AppliedTradeTax/xs:decimal(ram:RateApplicablePercent)=$rate and normalize-space(ram:AppliedTradeTax/ram:ExemptionReasonCode) = $exempReasonCode and normalize-space(ram:AppliedTradeTax/ram:ExemptionReason) = $exempReasonText]))
        return      
        abs($basisAmount - $calculatedAmountBT131 + $allowancesAmountBT92 - $chargesAmountBT99 - $logisticChargeAmount) le 0.01 * ($nbLineItems + $nbAllowancesOrCharges + $nblogisticCharge))">
	[BR-FXEXT-Z-08rev] - In a VAT breakdown (BG-23) where VAT category code (BT-118) is equal to “Z” ("Zero Rated"), Absolute Value of (VAT category taxable amount (BT-116) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-X-272)) &lt;= 0,01 * ((Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)), where the VAT category code (BT-151, BT-95, BT-102, BT-X-273) is "Zero Rated" (Z).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert id="BR-29" test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)">
	[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</assert>
      <assert id="BR-CO-19" test="(ram:StartDateTime) or (ram:EndDateTime)">
	[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='false']">
      <assert id="BR-31" test="(../ram:ActualAmount)">
	[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</assert>
      <assert id="BR-32" test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">
	[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</assert>
      <assert id="BR-33" test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</assert>
      <assert id="BR-CO-05" test="true()">
	[BR-CO-05]-Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</assert>
      <assert id="BR-CO-21" test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</assert>
      <assert id="BR-DEC-01" test="string-length(substring-after(../ram:ActualAmount[1],'.'))&lt;=2">
	[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</assert>
      <assert id="BR-DEC-02" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
	[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator='true']">
      <assert id="BR-36" test="(../ram:ActualAmount)">
	[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</assert>
      <assert id="BR-37" test="(../ram:CategoryTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">
	[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</assert>
      <assert id="BR-FXEXT-BR-38" test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-FXEXT-BR-38]-Each Document level charge or tax (BG-21) shall contain a Document level charge or tax reason (BT-104) or a Document level charge reason code (BT-105) or Document level non-VAT tax code (BT-177), or both reason and code.</assert>
      <assert id="BR-DEC-05" test="string-length(substring-after(../ram:ActualAmount[1],'.'))&lt;=2">
	[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</assert>
      <assert id="BR-DEC-06" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
	[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic">
      <assert id="BR-FXEXT-BR-54-1" test="exists(ram:Description) or exists(ram:TypeCode)">
	[BR-FXEXT-BR-54-1]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) or an Item attribute code (BT-X-11), or both.</assert>
      <assert id="BR-FXEXT-BR-54-2" test="(exists(ram:Value) and not(exists(ram:ValueMeasure))) or (not(exists(ram:Value)) and (exists(ram:ValueMeasure[@unitCode!=''])))">
	[BR-FXEXT-BR-54-2]-Each Item attribute (BG-32) shall contain an Item attribute value (BT-161) or an Item attribute value with unit of measure (BT-X-12, with BT-X-12-0), but noth both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableProductCharacteristic/ram:TypeCode">
      <assert flag="warning" id="BR-FXEXT-04" test="not(contains(normalize-space(.), ' ')) and contains(' A AAA AAB AAC AAD AAF AAG AAH AAI AAJ AAK AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABS ABT ABX ABY ABZ ACA ACE ACG ACN ACP ACS ACV ACW ACX ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX B BL BMY BMZ BNA BNB BNC BND BNE BNF BNG BNH BNI BNJ BNK BNL BNM BNN BNO BNP BNQ BNR BNS BNT BNU BNV BNW BNX BNY BNZ BR BRA BRB BRC BRD BRE BRF BRG BRH BRI BRJ BRK BRL BRM BRN BRO BRP BRQ BRR BRS BRT BRU BRV BS BSW BSX BSY BSZ BTA BTB BTC BTD BTE BTF BTG BTH BTI BTJ BTK BTL BTM BW CHN CHO CM CT CV CZ D DI DL DN DP DR DS DW E EA F FI FL FN FV GG GW HF HM HT IB ID L LM LN LND M MO MW N OD PRS PTN RA RF RJ RMW RP RUN RY SQ T TC TH TN TT VGM VH VW WA WD WM WU XH XQ XZ YS ZAL ZAS ZB ZBI ZC ZCA ZCB ZCE ZCL ZCO ZCR ZCU ZFE ZFS ZGE ZH ZK ZMG ZMN ZMO ZN ZNA ZNB ZNI ZO ZP ZPB ZS ZSB ZSE ZSI ZSL ZSN ZTA ZTE ZTI ZV ZW ZWA ZZN ZZR ZZZ BEST_BEFORE_DATE COLOR_TEXT COMMISSION DEPOSIT_SYSTEM DEPOSIT_TYPE ENERGY_CLASS EXPIRATION_DATE FEE KIND_OF_ARTICLE MATERIAL METER_LOCATION METER_NUMBER ORGANIC_CONTROL_BODY PACKAGING_MATERIAL PACKAGING_TYPE PROMOTIONAL_VARIANT SEAL_NUMBER SIZE_CODE SIZE_TEXT TRADING_UNIT WASTE_CODE WASTE_FRACTION WEEE_NUMBER ', concat(' ', normalize-space(.), ' '))">
	[BR-FXEXT-04]-To ensure automated processing of the article attributes without bilateral reconciliation, only values from the code list UNTDED 6313+Factur-X-Extension should be used. </assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:ApplicableTradeSettlementFinancialCard">
      <assert id="BR-51" test="string-length(normalize-space(ram:ID)) &lt;= 10">
	[BR-51]-In accordance with card payments security standards an invoice should never include a full card primary account number (BT-87). At the moment PCI Security Standards Council has defined that the first 6 digits and last 4 digits are the maximum number of digits to be shown.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:AssociatedDocumentLineDocument/ram:IncludedNote[ram:SubjectCode]">
      <assert id="BR-FXEXT-02" test="(ram:ContentCode) or (ram:Content)">
	[BR-FXEXT-02]-If the invoice line item free text subject code (BT-X-10) is specified, either the coded invoice line item free text (BT-X-9) or the invoice line item free text (BT-127) must be specified, or both. If both BT-X-9 and BT-127 are specified, both must have the same meaning.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem">
      <assert id="BR-FXEXT-06" test="normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID) ='' or (normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID) != '' and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode != '')">
	[BR-FXEXT-06]- For each item (BG-25), if the "ID of the parent line" (BT-X-304) is used, the "Subtype of the invoice item" (BT-X-8) must be specified.</assert>
      <assert id="BR-FXEXT-08" test="every $item in //ram:IncludedSupplyChainTradeLineItem[
        ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP'
        and normalize-space(ram:SpecifiedLineTradeSettlement/
                            ram:SpecifiedTradeSettlementLineMonetarySummation/
                            ram:LineTotalAmount) != ''
      ]
      satisfies
        number(normalize-space($item/ram:SpecifiedLineTradeSettlement/
                               ram:SpecifiedTradeSettlementLineMonetarySummation/
                               ram:LineTotalAmount))
        =
        round(sum(
          for $child in //ram:IncludedSupplyChainTradeLineItem[
            normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID)
              = normalize-space($item/ram:AssociatedDocumentLineDocument/ram:LineID)
            and (ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL'
                 or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP')
          ]
          return number(normalize-space(
            $child/ram:SpecifiedLineTradeSettlement/
            ram:SpecifiedTradeSettlementLineMonetarySummation/
            ram:LineTotalAmount))
        )*100) div 100">
	[BR-FXEXT-08]-If the "Subtype of invoice item" (BT-X-8) has the value "Subtotal" (GROUP) and the "Net amount of the invoice item" (BT-131) is specified, it must correspond to the sum of the BT-131 of the next lower levels for which the "Subtype of the invoice item" (BT-X-8) has the value "Regular item (standard case)" (DETAIL) or "Subtotal" (GROUP). As a consequence, all lower levels shall contain a BT-131 value, when BT-X-8 has the value DETAIL or GROUP.</assert>
      <assert id="BR-21" test="(ram:AssociatedDocumentLineDocument/ram:LineID!='')">
	[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</assert>
      <assert id="BR-25" test="(ram:SpecifiedTradeProduct/ram:Name!='')">
	[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</assert>
      <assert id="BR-64" test="ram:SpecifiedTradeProduct/ram:GlobalID/@schemeID!='' or not (ram:SpecifiedTradeProduct/ram:GlobalID)">
	[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</assert>
      <assert id="BR-65" test="(ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode/@listID!='') or not (ram:SpecifiedTradeProduct/ram:DesignatedProductClassification)">
	[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</assert>
      <assert id="BR-DEC-23" test="string-length(substring-after(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount,'.'))&lt;=2">
	[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem
               [normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID) != '']">
      <assert id="BR-FXEXT-11" test="some $p in //ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID
      satisfies normalize-space($p)
                = normalize-space(ram:AssociatedDocumentLineDocument/ram:ParentLineID)
    ">
	[BR-FXEXT-11]-Each "ID of parent line" (BT-X-304) must refer to an existing "ID of invoice item" (BT-126).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument[not(ram:LineStatusReasonCode) or ram:LineStatusReasonCode = 'DETAIL']">
      <assert id="BR-FXEXT-BR-22" test="(../ram:SpecifiedLineTradeDelivery/ram:BilledQuantity)">
	[BR-FXEXT-BR-22]-Each invoice line item "INVOICE LINE" (BG-25) must contain the quantity of goods or services invoiced in the relevant line item as a line item "Invoiced quantity" (BT-129) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
      <assert id="BR-FXEXT-BR-23" test="(../ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode)">
	[BR-FXEXT-BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
      <assert id="BR-FXEXT-BR-24" test="(../ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)">
	[BR-FXEXT-BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131), if the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified.</assert>
      <assert id="BR-FXEXT-BR-26" test="(../ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount)">
	[BR-FXEXT-BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
      <assert id="BR-FXEXT-CO-04" test="(../ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode = 'VAT') and (../ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[upper-case(ram:TypeCode) = 'VAT']/ram:CategoryCode)">
	[BR-FXEXT-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151) if the "Subtype of invoice line item" (BT-X-8) has the value "Normal line item (standard case)" (DETAIL) or is not specified.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP' and exists(ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)]">
      <assert id="BR-FXEXT-12" test="(for
        $lineID in ram:AssociatedDocumentLineDocument/ram:LineID,
        $numberChildWG in count(//rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID = $lineID and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP']),
        $numberChildWGAndBT131 in count(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem[ram:AssociatedDocumentLineDocument/ram:ParentLineID = $lineID and ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'GROUP']/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount)
        return
        ($numberChildWG = $numberChildWGAndBT131))">
	[BR-FXEXT-12]-If the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value  "GROUP" and if the "Invoice line net amount" (BT-131) is specified, all lower levels which has "Subtype of invoice line item" (EXT-FR-FE-163) equal to "GROUP" MUST contain a "Invoice line net amount" (BT-131) value.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:PayeeTradeParty">
      <assert id="BR-17" test="(ram:Name) and (not(ram:Name = ../ram:SellerTradeParty/ram:Name) and not(ram:ID = ../ram:SellerTradeParty/ram:ID) and not(ram:SpecifiedLegalOrganization/ram:ID = ../ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID))">
	[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTaxRepresentativeTradeParty">
      <assert id="BR-18" test="normalize-space(ram:Name) != ''">
	[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert id="BR-19" test="(ram:PostalTradeAddress)">
	[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert id="BR-20" test="normalize-space(ram:PostalTradeAddress/ram:CountryID) != ''">
	[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</assert>
      <assert id="BR-56" test="(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']!='')">
	[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SellerTradeParty">
      <assert id="BR-CO-26" test="(ram:ID) or (ram:GlobalID) or (ram:SpecifiedLegalOrganization/ram:ID) or (ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])">
	[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert id="BR-30" test="(ram:EndDateTime/udt:DateTimeString[@format = '102']) &gt;= (ram:StartDateTime/udt:DateTimeString[@format = '102']) or not (ram:EndDateTime) or not (ram:StartDateTime)">
	[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</assert>
      <assert id="BR-CO-20" test="(ram:StartDateTime) or (ram:EndDateTime)">
	[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']">
      <assert id="BR-42" test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'false']
">
      <assert id="BR-41" test="(../ram:ActualAmount)">
	[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</assert>
      <assert id="BR-CO-07" test="true()">
	[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</assert>
      <assert id="BR-CO-23" test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</assert>
      <assert id="BR-DEC-24" test="string-length(substring-after(../ram:ActualAmount[1],'.'))&lt;=2">
	[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</assert>
      <assert id="BR-DEC-25" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
	[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge/ram:ChargeIndicator[udt:Indicator = 'true']">
      <assert id="BR-43" test="(../ram:ActualAmount)">
	[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</assert>
      <assert id="BR-FXEXT-BR-44" test="(../ram:Reason) or (../ram:ReasonCode)">
	[BR-FXEXT-BR-44]-Each Invoice line charge or tax (BG-28) shall have an Invoice line charge or tax reason (BT-144), an Invoice line charge reason code (BT-145) or an Invoice line-level non-VAT tax type code (BT-193).</assert>
      <assert id="BR-DEC-27" test="string-length(substring-after(../ram:ActualAmount[1],'.'))&lt;=2">
	[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</assert>
      <assert id="BR-DEC-28" test="string-length(substring-after(../ram:BasisAmount,'.'))&lt;=2">
	[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']">
      <assert id="BR-CO-09" test="contains(' 1A AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', substring(.,1,2), ' '))">
	[BR-CO-09]-The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTaxRegistration/ram:ID[not(ancestor::ram:SellerTradeParty)]">
      <assert id="BR-FXEXT-03" test="@schemeID='VA'">
	[BR-FXEXT-03]-Only a VAT registration ID may be provided for the following business partners: the line level Ship-To (BT-X-66), the line level Ultimate-Ship-To (BT-X-84), the Sales-Agent (BT-X-340), the Buyer-Tax-Representative (BT-X-367), the Product-Enduser (BT-X-144), the Buyer-Agent (BT-X-411), the document level Ship-To (BT-X-161), the document level Ultimate-Ship-To (BT-X-180), the Ship-From (BT-X-199), the Invoicer (BT-X-223), the Invoicee (BT-X-242), the document level Payee (BT-X-257), the Payer (BT-X-481), or the payment-term-specific Payee (BT-X-509).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge">
      <assert id="CII-SR-472" test="count(ram:RateApplicablePercent) &lt;= 1">
	[CII-SR-472]-Each Specified Trade Allowance Charge (BG-20)(BG-21) should contain a VAT rate (BT-96).</assert>
      <assert id="CII-SR-471" test="count(ram:CategoryTradeTax) &lt;= 1">
	[CII-SR-471]-Each Specified Trade Allowance Charge (BG-20)(BG-21) shall contain a VAT category code (BT-95).</assert>
      <assert id="CII-SR-473" test="count(ram:ActualAmount) &lt;= 1">
	[CII-SR-473] - ActualAmount should exist maximum once</assert>
      <assert id="CII-SR-463" test="(ram:ChargeIndicator)">
	[CII-SR-463]-Each Specified Trade Allowance Charge (BG-20)(BG-21) shall contain a Charge Indicator.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']">
      <assert id="BR-AE-03" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="BR-AE-06" test="ram:RateApplicablePercent = 0">
	[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'E']">
      <assert id="BR-E-03" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-E-06" test="ram:RateApplicablePercent = 0">
	[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'G']">
      <assert id="BR-G-03" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
	[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-G-06" test="ram:RateApplicablePercent = 0">
	[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'K']">
      <assert id="BR-IC-03" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-IC-06" test="ram:RateApplicablePercent = 0">
	[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'L']">
      <assert id="BR-AF-03" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-AF-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-AF-06" test="ram:RateApplicablePercent &gt; 0">
	[BR-AF-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'M']">
      <assert id="BR-AG-03" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-AG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-AG-06" test="ram:RateApplicablePercent &gt;= 0">
	[BR-AG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'O']">
      <assert id="BR-O-06" test="not(ram:RateApplicablePercent)">
	[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'S']">
      <assert id="BR-S-03" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-S-06" test="ram:RateApplicablePercent &gt; 0">
	[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']">
      <assert id="BR-Z-03" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-Z-06" test="ram:RateApplicablePercent = 0">
	[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'AE']">
      <assert id="BR-AE-04" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="BR-AE-07" test="ram:RateApplicablePercent = 0">
	[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'E']">
      <assert id="BR-E-04" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-E-07" test="ram:RateApplicablePercent = 0">
	[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'G']">
      <assert id="BR-G-04" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
	[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-G-07" test="ram:RateApplicablePercent = 0">
	[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'K']">
      <assert id="BR-IC-04" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-IC-07" test="ram:RateApplicablePercent = 0">
	[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'L']">
      <assert id="BR-AF-04" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-AF-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-AF-07" test="ram:RateApplicablePercent &gt; 0">
	[BR-AF-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'M']">
      <assert id="BR-AG-04" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-AG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-AG-07" test="ram:RateApplicablePercent &gt;= 0">
	[BR-AG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'O']">
      <assert id="BR-O-07" test="not(ram:RateApplicablePercent)">
	[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'S']">
      <assert id="BR-S-04" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-S-07" test="ram:RateApplicablePercent &gt; 0">
	[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:CategoryTradeTax[ram:CategoryCode = 'Z']">
      <assert id="BR-Z-04" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-Z-07" test="ram:RateApplicablePercent = 0">
	[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert id="BR-FXEXT-CO-10" test="for $calculatedAmount in xs:decimal(round(sum(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)
 or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * xs:decimal(100)) div xs:decimal(100)),
            $totalAmount in xs:decimal(ram:LineTotalAmount),
            $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem)),
            $tolerance in xs:decimal(0.01),
            $maxTolerance in $nbLineItems * $tolerance,
            $diff in xs:decimal($totalAmount - $calculatedAmount),
            $abs in xs:decimal(abs($diff))
        return
        $abs le $maxTolerance">
	[BR-FXEXT-CO-10]-Absolute Value of (Sum of Invoice line net amount (BT-106) - Σ Invoice line net amounts (BT-131))&lt;= 0,01 * Number of line net amounts (BT-131).</assert>
      <assert id="BR-12" test="(ram:LineTotalAmount)">
	[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</assert>
      <assert id="BR-13" test="(ram:TaxBasisTotalAmount)">
	[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</assert>
      <assert id="BR-14" test="(ram:GrandTotalAmount)">
	[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</assert>
      <assert id="BR-15" test="(ram:DuePayableAmount)">
	[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</assert>
      <assert id="BR-FXEXT-CO-11" test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']) and not (ram:AllowanceTotalAmount)) or
(for $calculatedAmount in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:ActualAmount)* 10 * 10 ) div 100),
            $totalAmount in xs:decimal(ram:AllowanceTotalAmount),
            $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),
            $tolerance in xs:decimal(0.01),
            $maxTolerance in $nbAllowanceItems * $tolerance,
            $diff in xs:decimal($totalAmount - $calculatedAmount),
            $abs in xs:decimal(abs($diff))
        return
        $abs le $maxTolerance)">
	[BR-FXEXT-CO-11]-Absolute Value of (Sum of allowances on document level (BT-107) - Σ Document level allowance amounts (BT-92))&lt;= 0,01 * Number of Document level allowance amounts (BT-92).</assert>
      <assert id="BR-FXEXT-CO-12" test="(not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true'])and not (ram:ChargeTotalAmount)) 
or
(for $calculatedAmount in xs:decimal(xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:ActualAmount)* 100 ) div 100)+ xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100)),
            $totalAmount in xs:decimal(ram:ChargeTotalAmount),
                        $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),
            $tolerance in xs:decimal(0.01),
            $maxTolerance in $nbChargeItems * $tolerance,
            $diff in xs:decimal($totalAmount - $calculatedAmount),
            $abs in xs:decimal(abs($diff))
        return
        $abs le $maxTolerance)">
	[BR-FXEXT-CO-12]-Absolute Value of (Sum of charges on document level (BT-108) - Σ Document level charge amounts (BT-99) - Σ Logistics Service fee amounts (BT-x-272))&lt;= 0,01 * (Number of Document level charge amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272)).</assert>
      <assert id="BR-FXEXT-CO-13" test="for $BT109 in xs:decimal(ram:TaxBasisTotalAmount),
   $BT131Sum in xs:decimal(round(sum(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)
 or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount) * xs:decimal(100)) div xs:decimal(100)),
   $BT92Sum in xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false']/ram:ActualAmount)* 10 * 10 ) div 100),
   $BT99Sum in xs:decimal(xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']/ram:ActualAmount)* 100 ) div 100)+ xs:decimal(round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount)* 10 * 10 ) div 100)),
   $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)
 or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL'])),
   $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),
   $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),
            $tolerance in xs:decimal(0.01),
            $maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),
            $diff in xs:decimal($BT109 - $BT131Sum + $BT92Sum - $BT99Sum),
            $abs in xs:decimal(abs($diff))
        return
        $abs le $maxTolerance">
	[BR-FXEXT-CO-13]-Absolute Value of (Invoice total amount without VAT (BT-109) - ∑ Invoice line net amounts (BT-131) + Σ Document level allowance amounts (BT-92) - Σ Document level charge amounts (BT-99)) &lt;= 0,01 * (Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charge amounts (BT-99)).</assert>
      <assert id="BR-FXEXT-CO-15" test="for $Currency in ../ram:InvoiceCurrencyCode,
   $BT109 in xs:decimal(ram:TaxBasisTotalAmount),
   $BT110 in xs:decimal(ram:TaxTotalAmount[@currencyID=$Currency]),   
   $BT112 in xs:decimal(ram:GrandTotalAmount),
   $nbTaxTotalAmountInvoiceCurrency in count (ram:TaxTotalAmount[@currencyID=$Currency] ),
   $nbLineItems in xs:decimal(count(../../ram:IncludedSupplyChainTradeLineItem[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode)
 or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL'])),
   $nbAllowanceItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='false'])),
   $nbChargeItems in xs:decimal(count(../ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator='true']) + count(../ram:SpecifiedLogisticsServiceCharge)),
   $tolerance in xs:decimal(0.01),
   $maxTolerance in $tolerance * ($nbLineItems + $nbAllowanceItems + $nbChargeItems),
   $diff in xs:decimal($BT112 - $BT110 - $BT109),
   $abs in xs:decimal(abs($diff))
return
  ($abs le $maxTolerance and $nbTaxTotalAmountInvoiceCurrency eq 1) or
  ($BT109 eq $BT112 and $nbTaxTotalAmountInvoiceCurrency ne 1)">
	[BR-FXEXT-CO-15]-If Invoice Total VAT amount (BT-110) ,where currency (BT-110-0) is equal to BT-5, is present, then the Absolute Value of (Invoice total amount with VAT (BT-112) - Invoice total amount without VAT (BT-109) - Invoice total VAT amount (BT-110)) &lt;= 0,01 * (Number of line net amounts (BT-131) + Number of Document level allowance amounts (BT-92) + Number of Document level charges amounts (BT-99) + Number of Logistics Service fee amounts (BT-X-272). Else, Invoice total amount with VAT (BT-112) is equal to Invoice total amount without VAT (BT-109).</assert>
      <assert id="BR-FXEXT-CO-16" test="xs:decimal(ram:DuePayableAmount) = xs:decimal(sum(ram:GrandTotalAmount/xs:decimal(.))) - xs:decimal(sum(ram:TotalPrepaidAmount/xs:decimal(.))) + xs:decimal(sum(ram:RoundingAmount/xs:decimal(.))) + xs:decimal(sum(../ram:SpecifiedFinancialAdjustment/ram:ActualAmount/xs:decimal(.)))">
	[BR-FXEXT-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) + Rounding amount (BT-114) + Sum of Charge amount collected on behalf of a third party (BT-179).</assert>
      <assert id="BR-DEC-09" test="string-length(substring-after(ram:LineTotalAmount,'.'))&lt;=2">
	[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</assert>
      <assert id="BR-DEC-10" test="string-length(substring-after(ram:AllowanceTotalAmount,'.'))&lt;=2">
	[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowances on document level (BT-107) is 2.</assert>
      <assert id="BR-DEC-11" test="string-length(substring-after(ram:ChargeTotalAmount,'.'))&lt;=2">
	[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</assert>
      <assert id="BR-DEC-12" test="string-length(substring-after(ram:TaxBasisTotalAmount,'.'))&lt;=2">
	[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</assert>
      <assert id="BR-DEC-13" test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode and . = round(. * 100) div 100) or not (@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode)]">
	[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</assert>
      <assert id="BR-DEC-14" test="string-length(substring-after(ram:GrandTotalAmount,'.'))&lt;=2">
	[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</assert>
      <assert id="BR-DEC-15" test="not(ram:TaxTotalAmount) or ram:TaxTotalAmount[(@currencyID =/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and . = round(. * 100) div 100) or not (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">
	[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</assert>
      <assert id="BR-DEC-16" test="string-length(substring-after(ram:TotalPrepaidAmount,'.'))&lt;=2">
	[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</assert>
      <assert id="BR-DEC-17" test="string-length(substring-after(ram:RoundingAmount,'.'))&lt;=2">
	[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</assert>
      <assert id="BR-DEC-18" test="string-length(substring-after(ram:DuePayableAmount,'.'))&lt;=2">
	[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.</assert>
      <assert id="BR-53" test="not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) or (/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode and (ram:TaxTotalAmount/@currencyID = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode) and not(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode = /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode))">
	[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]">
      <assert id="BR-CO-14" test=". = (round(sum(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount)*10*10)div 100)">
	[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans">
      <assert id="BR-49" test="(ram:TypeCode)">
	[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</assert>
      <assert id="CII-SR-464" test="(ram:PayeeSpecifiedCreditorFinancialInstitution or ram:PayerSpecifiedDebtorFinancialInstitution) or (not(ram:PayeeSpecifiedCreditorFinancialInstitution) and not(ram:PayerSpecifiedDebtorFinancialInstitution))">
	[CII-SR-464]-Only one BT-86 element is allowed on an invoice.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//ram:SpecifiedTradeSettlementPaymentMeans[ram:TypeCode='30' or ram:TypeCode='58']/ram:PayeePartyCreditorFinancialAccount">
      <assert id="BR-50" test="normalize-space(ram:IBANID) != '' or normalize-space(ram:ProprietaryID) != ''">
	[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-16) information is provided in the Invoice.</assert>
      <assert id="BR-61" test="(ram:IBANID) or (ram:ProprietaryID)">
	[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert id="BR-CO-18" test="ram:ApplicableTradeTax">
	[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'AE']">
      <assert id="BR-AE-09" test="../ram:CalculatedAmount = 0">
	[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</assert>
      <assert id="BR-AE-10" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-AE-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'E']">
      <assert id="BR-E-09" test="../ram:CalculatedAmount = 0">
	[BR-E-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</assert>
      <assert id="BR-E-10" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-E-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[. = 'G']">
      <assert id="BR-G-09" test="../ram:CalculatedAmount = 0">
	[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</assert>
      <assert id="BR-G-10" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-G-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode[.= 'K']">
      <assert id="BR-IC-09" test="../ram:CalculatedAmount = 0">
	[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</assert>
      <assert id="BR-IC-10" test="(../ram:ExemptionReason) or (../ram:ExemptionReasonCode)">
	[BR-IC-10]-A VAT Breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
      <assert id="BR-IC-11" test="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)">
	[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</assert>
      <assert id="BR-IC-12" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
	[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']">
      <assert id="BR-AF-09" test="true()">
	[BR-AF-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']">
      <assert id="BR-AG-09" test="true()">
	[BR-AG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']">
      <assert id="BR-O-09" test="ram:CalculatedAmount = 0">
	[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</assert>
      <assert id="BR-O-10" test="(ram:ExemptionReason) or (ram:ExemptionReasonCode)">
	[BR-O-10]-A VAT Breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'AE']">
      <assert id="BR-AE-02" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and (//ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID)">
	[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</assert>
      <assert id="BR-AE-05" test="ram:RateApplicablePercent = 0">
	[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'E']">
      <assert id="BR-E-02" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-E-05" test="ram:RateApplicablePercent = 0">
	[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'G']">
      <assert id="BR-G-02" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'])">
	[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-G-05" test="ram:RateApplicablePercent = 0">
	[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'K']">
      <assert id="BR-IC-02" test="(//ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA'] or //ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']) and //ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</assert>
      <assert id="BR-IC-05" test="ram:RateApplicablePercent = 0">
	[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'L']">
      <assert id="BR-AF-02" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-AF-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-AF-05" test="ram:RateApplicablePercent &gt; 0">
	[BR-AF-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be greater than 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'M']">
      <assert id="BR-AG-02" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-AG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-AG-05" test="ram:RateApplicablePercent &gt;= 0">
	[BR-AG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'O']">
      <assert id="BR-O-05" test="not(ram:RateApplicablePercent)">
	[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'S']">
      <assert id="BR-S-02" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-S-05" test="ram:RateApplicablePercent &gt; 0">
	[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode = 'Z']">
      <assert id="BR-Z-02" test="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = ('VA', 'FC')] or /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID = 'VA']">
	[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</assert>
      <assert id="BR-Z-05" test="ram:RateApplicablePercent = 0">
	[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//udt:DateTimeString[@format = '102']">
      <assert id="CII-DT-097" test="matches(.,'^\s*(\d{4})(1[0-2]|0[1-9]){1}(3[01]|[12][0-9]|0[1-9]){1}\s*$')">
	[CII-DT-097]-Date time string with format attribute 102 shall be YYYYMMDD.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="//udt:DateTimeString[@format = '205']">
      <assert id="BR-FXEXT-CII-DT-097a" test="matches(., '^\s*(\d{4})(1[0-2]|0[1-9])(3[01]|[12][0-9]|0[1-9])([01][0-9]|2[0-3])[0-5][0-9]\s*$')">
	[BR-FXEXT-CII-DT-097a]-Date time string with format attribute 205 shall be YYYYMMDDHHMMSS.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice">
      <assert id="BR-16" test="//ram:IncludedSupplyChainTradeLineItem">
	[BR-16]-An Invoice shall have at least one Invoice line (BG-25).</assert>
      <assert id="BR-CO-25" test="(number(//ram:DuePayableAmount) &gt; 0 and ((//ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime) or (//ram:SpecifiedTradePaymentTerms/ram:Description))) or not(number(//ram:DuePayableAmount) &gt; 0)">
	[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</assert>
      <assert id="BR-01" test="(rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID != '')">
	[BR-01]-An Invoice shall have a Specification identifier (BT-24).</assert>
      <assert id="BR-02" test="(rsm:ExchangedDocument/ram:ID !='')">
	[BR-02]-An Invoice shall have an Invoice number (BT-1).</assert>
      <assert id="BR-03" test="(rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format='102']!='')">
	[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</assert>
      <assert id="BR-04" test="(rsm:ExchangedDocument/ram:TypeCode!='')">
	[BR-04]-An Invoice shall have an Invoice type code (BT-3).</assert>
      <assert id="BR-05" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode!='')">
	[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</assert>
      <assert id="BR-06" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name!='')">
	[BR-06]-An Invoice shall contain the Seller name (BT-27).</assert>
      <assert id="BR-07" test="(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name!='')">
	[BR-07]-An Invoice shall contain the Buyer name (BT-44).</assert>
      <assert id="BR-08" test="//ram:SellerTradeParty/ram:PostalTradeAddress">
	[BR-08]-An Invoice shall contain the Seller postal address (BG-5).</assert>
      <assert id="BR-09" test="//ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">
	[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</assert>
      <assert id="BR-10" test="//ram:BuyerTradeParty/ram:PostalTradeAddress">
	[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</assert>
      <assert id="BR-11" test="//ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID!=''">
	[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</assert>
      <assert id="BR-62" test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication)">
	[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</assert>
      <assert id="BR-63" test="normalize-space(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication[1]/ram:URIID/@schemeID) != '' or not (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication)">
	[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.</assert>
      <assert id="BR-FXEXT-S-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='S'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='S'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='S'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='S'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='S']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='S']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='S'])))">
	[BR-FXEXT-S-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “S” ("Standard rated") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “S” ("Standard rated").</assert>
      <assert id="BR-FXEXT-Z-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='Z'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='Z'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='Z'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='Z']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='Z']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='Z'])))">
	[BR-FXEXT-Z-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice item" (BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “Z” ("Zero Rated") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “Z” ("Zero Rated").</assert>
      <assert id="BR-FXEXT-E-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='E'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='E'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='E'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='E']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='E']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='E'])))">
	[BR-FXEXT-E-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is "E" ("Exempt from VAT") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "E" ("Exempt from VAT").</assert>
      <assert id="BR-FXEXT-AE-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='AE'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='AE'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='AE'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='AE']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='AE']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='AE'])))">
	[BR-FXEXT-AE-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (EXT-FR-FE-163 / BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “AE” ("Reverse Charge") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “AE” ("Reverse Charge").</assert>
      <assert id="BR-FXEXT-IC-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='K'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='K'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='K'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='K'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='K']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='K']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='K'])))">
	[BR-FXEXT-IC-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “K” ("Intra-community supply") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “K” ("Intra-community supply").</assert>
      <assert id="BR-FXEXT-G-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='G'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='G'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='G'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='G'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='G']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='G']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='G'])))">
	[BR-FXEXT-G-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" ( BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “G” ("Export outside the EU") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “G” ("Export outside the EU").</assert>
      <assert id="BR-FXEXT-O-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='O'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='O'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='O'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='O'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='O']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='O']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='O'])))">
	[BR-FXEXT-O-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “O” ("Not subject to VAT") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “O” ("Not subject to VAT").</assert>
      <assert id="BR-FXEXT-AF-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='L'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='L'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='L'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='L'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='L']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='L']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='L'])))">
	[BR-FXEXT-AF-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “L” ("Canary Islands tax") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “L” ("Canary Islands tax").</assert>
      <assert id="BR-FXEXT-AG-01" test="(count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])=0 and count(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='M'])=0 and count(//ram:CategoryTradeTax[ram:CategoryCode='M'])=0 and count(//ram:AppliedTradeTax[ram:CategoryCode='M'])=0) or ( count(//ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='M'])&gt;=1 and (exists(//ram:SpecifiedLineTradeSettlement[not(ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode) or ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode = 'DETAIL']/ram:ApplicableTradeTax[ram:CategoryCode='M']) or exists(//ram:CategoryTradeTax[ram:CategoryCode='M']) or exists(//ram:AppliedTradeTax[ram:CategoryCode='M'])))">
	[BR-FXEXT-AG-01]-An Invoice that contains an Invoice line (BG-25) where the "Subtype of invoice line item" (BT-X-8) has the value "DETAIL" or is not specified, a Document level allowance (BG-20) or a Document level charge or tax (BG-21) or a Logistics Service Charge ( BG-X-42) where the VAT category code (BT-151, BT-95, BT-102, or BT-X-273) is “M” ("Ceuta and Mellita tax") shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with “M” ("Ceuta and Melilla tax").</assert>
      <assert id="CII-SR-467" test="count(//ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode[normalize-space(.) != normalize-space((//ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode)[1])]) = 0">
	[CII-SR-467] - All Payment means type codes (BT-81) shall have the same value across all SpecifiedTradeSettlementPaymentMeans.</assert>
      <assert id="CII-SR-468" test="count(//ram:SpecifiedTradeSettlementPaymentMeans/ram:Information[normalize-space(.) != normalize-space((//ram:SpecifiedTradeSettlementPaymentMeans/ram:Information)[1])]) = 0">
	[CII-SR-468] - All Payment means texts (BT-82) shall have the same value across all SpecifiedTradeSettlementPaymentMeans.</assert>
      <assert id="CII-SR-469" test="count(//ram:ApplicableHeaderTradeSettlement/ram:PaymentReference) &lt;= 1">
	[CII-SR-469] - Payment reference (BT-83) shall occur at most once in the document.</assert>
      <assert id="BR-B-01" test="(not(//ram:CountryID != 'IT') and //ram:CategoryCode ='B') or (not(//ram:CategoryCode ='B'))">
	[BR-B-01]-An Invoice where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment” shall be a domestic Italian invoice.</assert>
      <assert id="BR-B-02" test="(//ram:CategoryCode ='B' and (not(//ram:CategoryCode ='S'))) or (not(//ram:CategoryCode ='B'))">
	[BR-B-02]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Split payment" shall not contain an invoice line (BG-25), a Document level allowance (BG-20) or  a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is “Standard rated”.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote[ram:SubjectCode]">
      <assert id="BR-FXEXT-01" test="(ram:ContentCode) or (ram:Content)">
	[BR-FXEXT-01]-If the Invoice Free Text subject Code (BT-21) is specified, either the coded message free text (BT-X-5) or the message free text (BT-22) must be specified, or both. If both BT-X-5 and BT-22 are specified, both must have the same meaning.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert flag="warning" id="CII-SR-475" test="count(ram:AdditionalReferencedDocument[normalize-space(ram:TypeCode) = '916']/ram:Name) &lt;= 1">
	[CII-SR-475] - Only one AdditionalReferencedDocument Name BT-123 is allowed with TypeCode 916.</assert>
      <assert flag="warning" id="CII-SR-476" test="count(ram:AdditionalReferencedDocument[normalize-space(ram:TypeCode) = '916']/ram:AttachmentBinaryObject) &lt;= 1">
	[CII-SR-476] - Only one AdditionalReferencedDocument AttachmentBinaryObject BT-125 is allowed with TypeCode 916.</assert>
      <assert id="CII-SR-465" test="not(ram:SellerTradeParty/ram:DefinedTradeContact/ram:PersonName and ram:SellerTradeParty/ram:DefinedTradeContact/ram:DepartmentName)">
	[CII-SR-465]-Only one BT-41 element is allowed on an invoice.</assert>
      <assert id="CII-SR-466" test="not(ram:BuyerTradeParty/ram:DefinedTradeContact/ram:PersonName and ram:BuyerTradeParty/ram:DefinedTradeContact/ram:DepartmentName)">
	[CII-SR-466]-Only one BT-56 element is allowed on an invoice.</assert>
      <assert id="FX-SCH-A-000027" test="count(ram:SellerTradeParty)=1">
	Element 'ram:SellerTradeParty' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000028" test="count(ram:BuyerTradeParty)=1">
	Element 'ram:BuyerTradeParty' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery">
      <assert id="BR-57" test="(ram:ShipToTradeParty/ram:PostalTradeAddress and ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID!='') or not (ram:ShipToTradeParty/ram:PostalTradeAddress)">
	[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <assert id="BR-55" test="(ram:IssuerAssignedID!='')">
	[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</assert>
      <assert id="FX-SCH-A-000415" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <assert id="FX-SCH-A-000019" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000630" test="count(ram:Name)&lt;=1">
	Element 'ram:Name' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000020" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000315" test="count(ram:LanguageID)&lt;=1">
	Element 'ram:LanguageID' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod">
      <assert id="FX-SCH-A-000316" test="count(ram:CompleteDateTime)=1">
	Element 'ram:CompleteDateTime' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:CompleteDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000631" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000632" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:EndDateTime">
      <report test="true()">
	Element 'ram:EndDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:StartDateTime">
      <report test="true()">
	Element 'ram:StartDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote">
      <assert id="FX-SCH-A-000317" test="count(ram:Content)&lt;=1">
	Element 'ram:Content' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000161" test="count(ram:SubjectCode)&lt;=1">
	Element 'ram:SubjectCode' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:ContentCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue5" value="."/>
      <assert id="FX-SCH-A-000633" test="string-length($codeValue5)=0 or ($codeValue5 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT', 'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE', 'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP', 'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABZ', 'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACM', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACS', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX', 'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADH', 'ADI', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADR', 'ADS', 'ADT', 'ADU', 'ADV', 'ADW', 'ADX', 'ADY', 'ADZ', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AFA', 'AFB', 'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM', 'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX', 'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI', 'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT', 'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE', 'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP', 'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHW', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB', 'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM', 'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX', 'AIY', 'AIZ', 'AJA', 'AJB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL', 'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ARR', 'ARS', 'AUT', 'AUU', 'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE', 'AVF', 'BAG', 'BAH', 'BAI', 'BAJ', 'BAK', 'BAL', 'BAM', 'BAN', 'BAO', 'BAP', 'BAQ', 'BAR', 'BAS', 'BAT', 'BAU', 'BAV', 'BAW', 'BAX', 'BAY', 'BAZ', 'BBA', 'BBB', 'BLC', 'BLD', 'BLE', 'BLF', 'BLG', 'BLH', 'BLI', 'BLJ', 'BLK', 'BLL', 'BLM', 'BLN', 'BLO', 'BLP', 'BLQ', 'BLR', 'BLS', 'BLT', 'BLU', 'BLV', 'BLW', 'BLX', 'BLY', 'BLZ', 'BMA', 'BMB', 'BMC', 'BMD', 'BME', 'BMF', 'BMG', 'BMH', 'CCI', 'CCJ', 'CCK', 'CCL', 'CCM', 'CCN', 'CCO', 'CEX', 'CHG', 'CIP', 'CLP', 'CLR', 'COI', 'CUR', 'CUS', 'DAR', 'DCL', 'DEL', 'DIN', 'DOC', 'DUT', 'EUR', 'FBC', 'GBL', 'GEN', 'GS7', 'HAN', 'HAZ', 'ICN', 'IIN', 'IMI', 'IND', 'INS', 'INV', 'IRP', 'ITR', 'ITS', 'LAN', 'LIN', 'LOI', 'MCO', 'MDH', 'MKS', 'ORI', 'OSI', 'PAC', 'PAI', 'PAY', 'PKG', 'PKT', 'PMD', 'PMT', 'PRD', 'PRF', 'PRI', 'PUR', 'QIN', 'QQD', 'QUT', 'RAH', 'REG', 'RET', 'REV', 'RQR', 'SAF', 'SIC', 'SIN', 'SLR', 'SPA', 'SPG', 'SPH', 'SPP', 'SPT', 'SRN', 'SSR', 'SUR', 'TCA', 'TDT', 'TRA', 'TRR', 'TXD', 'WHI', 'ZZZ'))">
	Value of 'ram:SubjectCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000021" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000634" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:LanguageID">
      <let name="codeValue4" value="."/>
      <assert id="FX-SCH-A-000389" test="string-length($codeValue4)=0 or ($codeValue4 = ('aar', 'abk', 'ace', 'ach', 'ada', 'ady', 'afa', 'afh', 'afr', 'ain', 'aka', 'akk', 'alb', 'ale', 'alg', 'alt', 'amh', 'ang', 'anp', 'apa', 'ara', 'arc', 'arg', 'arm', 'arn', 'arp', 'art', 'arw', 'asm', 'ast', 'ath', 'aus', 'ava', 'ave', 'awa', 'aym', 'aze', 'bad', 'bai', 'bak', 'bal', 'bam', 'ban', 'baq', 'bas', 'bat', 'bej', 'bel', 'bem', 'ben', 'ber', 'bho', 'bih', 'bik', 'bin', 'bis', 'bla', 'bnt', 'bod', 'bos', 'bra', 'bre', 'btk', 'bua', 'bug', 'bul', 'bur', 'byn', 'cad', 'cai', 'car', 'cat', 'cau', 'ceb', 'cel', 'ces', 'cha', 'chb', 'che', 'chg', 'chk', 'chm', 'chn', 'cho', 'chp', 'chr', 'chu', 'chv', 'chy', 'cmc', 'cnr', 'cop', 'cor', 'cos', 'cpe', 'cpf', 'cpp', 'cre', 'crh', 'crp', 'csb', 'cus', 'cym', 'cze', 'dak', 'dan', 'dar', 'day', 'del', 'den', 'deu', 'dgr', 'din', 'div', 'doi', 'dra', 'dsb', 'dua', 'dum', 'dut', 'dyu', 'dzo', 'efi', 'egy', 'eka', 'ell', 'elx', 'eng', 'enm', 'epo', 'est', 'eus', 'ewe', 'ewo', 'fan', 'fao', 'fas', 'fat', 'fij', 'fil', 'fin', 'fiu', 'fon', 'fra', 'fre', 'frm', 'fro', 'frr', 'frs', 'fry', 'ful', 'fur', 'gaa', 'gay', 'gba', 'gem', 'geo', 'ger', 'gez', 'gil', 'gla', 'gle', 'glg', 'glv', 'gmh', 'goh', 'gon', 'gor', 'got', 'grb', 'grc', 'gre', 'grn', 'gsw', 'guj', 'gwi', 'hai', 'hat', 'hau', 'haw', 'heb', 'her', 'hil', 'him', 'hin', 'hit', 'hmn', 'hmo', 'hrv', 'hsb', 'hun', 'hup', 'hye', 'iba', 'ibo', 'ice', 'ido', 'iii', 'ijo', 'iku', 'ile', 'ilo', 'ina', 'inc', 'ind', 'ine', 'inh', 'ipk', 'ira', 'iro', 'isl', 'ita', 'jav', 'jbo', 'jpn', 'jpr', 'jrb', 'kaa', 'kab', 'kac', 'kal', 'kam', 'kan', 'kar', 'kas', 'kat', 'kau', 'kaw', 'kaz', 'kbd', 'kha', 'khi', 'khm', 'kho', 'kik', 'kin', 'kir', 'kmb', 'kok', 'kom', 'kon', 'kor', 'kos', 'kpe', 'krc', 'krl', 'kro', 'kru', 'kua', 'kum', 'kur', 'kut', 'lad', 'lah', 'lam', 'lao', 'lat', 'lav', 'lez', 'lim', 'lin', 'lit', 'lol', 'loz', 'ltz', 'lua', 'lub', 'lug', 'lui', 'lun', 'luo', 'lus', 'mac', 'mad', 'mag', 'mah', 'mai', 'mak', 'mal', 'man', 'mao', 'map', 'mar', 'mas', 'may', 'mdf', 'mdr', 'men', 'mga', 'mic', 'min', 'mis', 'mkd', 'mkh', 'mlg', 'mlt', 'mnc', 'mni', 'mno', 'moh', 'mon', 'mos', 'mri', 'msa', 'mul', 'mun', 'mus', 'mwl', 'mwr', 'mya', 'myn', 'myv', 'nah', 'nai', 'nap', 'nau', 'nav', 'nbl', 'nde', 'ndo', 'nds', 'nep', 'new', 'nia', 'nic', 'niu', 'nld', 'nno', 'nob', 'nog', 'non', 'nor', 'nqo', 'nso', 'nub', 'nwc', 'nya', 'nym', 'nyn', 'nyo', 'nzi', 'oci', 'oji', 'ori', 'orm', 'osa', 'oss', 'ota', 'oto', 'paa', 'pag', 'pal', 'pam', 'pan', 'pap', 'pau', 'peo', 'per', 'phi', 'phn', 'pli', 'pol', 'pon', 'por', 'pra', 'pro', 'pus', 'qaa-qtz', 'que', 'raj', 'rap', 'rar', 'roa', 'roh', 'rom', 'ron', 'rum', 'run', 'rup', 'rus', 'sad', 'sag', 'sah', 'sai', 'sal', 'sam', 'san', 'sas', 'sat', 'scn', 'sco', 'sel', 'sem', 'sga', 'sgn', 'shn', 'sid', 'sin', 'sio', 'sit', 'sla', 'slk', 'slo', 'slv', 'sma', 'sme', 'smi', 'smj', 'smn', 'smo', 'sms', 'sna', 'snd', 'snk', 'sog', 'som', 'son', 'sot', 'spa', 'sqi', 'srd', 'srn', 'srp', 'srr', 'ssa', 'ssw', 'suk', 'sun', 'sus', 'sux', 'swa', 'swe', 'syc', 'syr', 'tah', 'tai', 'tam', 'tat', 'tel', 'tem', 'ter', 'tet', 'tgk', 'tgl', 'tha', 'tib', 'tig', 'tir', 'tiv', 'tkl', 'tlh', 'tli', 'tmh', 'tog', 'ton', 'tpi', 'tsi', 'tsn', 'tso', 'tuk', 'tum', 'tup', 'tur', 'tut', 'tvl', 'twi', 'tyv', 'udm', 'uga', 'uig', 'ukr', 'umb', 'und', 'urd', 'uzb', 'vai', 'ven', 'vie', 'vol', 'vot', 'wak', 'wal', 'war', 'was', 'wel', 'wen', 'wln', 'wol', 'xal', 'xho', 'yao', 'yap', 'yid', 'yor', 'ypk', 'zap', 'zbl', 'zen', 'zgh', 'zha', 'zho', 'znd', 'zul', 'zun', 'zxx', 'zza'))">
	Value of 'ram:LanguageID' is not allowed.</assert>
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <let name="codeValue2" value="."/>
      <assert id="FX-SCH-A-000635" test="string-length($codeValue2)=0 or ($codeValue2 = ('71', '80', '81', '82', '83', '84', '102', '130', '202', '203', '204', '211', '218', '219', '261', '262', '295', '296', '308', '325', '326', '331', '380', '381', '382', '383', '384', '385', '386', '387', '388', '389', '390', '393', '394', '395', '396', '420', '456', '457', '458', '471', '472', '473', '500', '501', '502', '503', '527', '532', '553', '575', '623', '633', '751', '780', '817', '870', '875', '876', '877', '935'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <assert id="FX-SCH-A-000024" test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1">
	Element 'ram:BusinessProcessSpecifiedDocumentContextParameter' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000025" test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1">
	Element 'ram:GuidelineSpecifiedDocumentContextParameter' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter">
      <assert id="FX-SCH-A-000406" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter">
      <assert id="FX-SCH-A-000407" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID">
      <let name="codeValue1" value="."/>
      <assert id="FX-SCH-A-000636" test="string-length($codeValue1)=0 or ($codeValue1 = ('urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended', 'urn:cen.eu:en16931:2017#conformant#urn:zugferd.de:2p0:extended'))">
	Value of 'ram:ID' is not allowed.</assert>
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction">
      <assert id="FX-SCH-A-000265" test="count(ram:IncludedSupplyChainTradeLineItem)&gt;=1">
	Element 'ram:IncludedSupplyChainTradeLineItem' must occur at least 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ not(ram:TypeCode=&quot;916&quot;) and  not(ram:TypeCode=&quot;50&quot;) and  not(ram:TypeCode=&quot;130&quot;)]">
      <report test="true()">
	Element variant 'ram:AdditionalReferencedDocument[ not(ram:TypeCode="916") and  not(ram:TypeCode="50") and  not(ram:TypeCode="130")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]">
      <assert id="FX-SCH-A-000557" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000558" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000637" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000638" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:ReferenceTypeCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-000639" test="string-length($codeValue20)=0 or ($codeValue20 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT', 'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE', 'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP', 'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABY', 'ABZ', 'AC', 'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX', 'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADI', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADT', 'ADU', 'ADV', 'ADW', 'ADX', 'ADY', 'ADZ', 'AE', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AF', 'AFA', 'AFB', 'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM', 'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX', 'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI', 'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT', 'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE', 'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP', 'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB', 'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM', 'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX', 'AIY', 'AIZ', 'AJA', 'AJB', 'AJC', 'AJD', 'AJE', 'AJF', 'AJG', 'AJH', 'AJI', 'AJJ', 'AJK', 'AJL', 'AJM', 'AJN', 'AJO', 'AJP', 'AJQ', 'AJR', 'AJS', 'AJT', 'AJU', 'AJV', 'AJW', 'AJX', 'AJY', 'AJZ', 'AKA', 'AKB', 'AKC', 'AKD', 'AKE', 'AKF', 'AKG', 'AKH', 'AKI', 'AKJ', 'AKK', 'AKL', 'AKM', 'AKN', 'AKO', 'AKP', 'AKQ', 'AKR', 'AKS', 'AKT', 'AKU', 'AKV', 'AKW', 'AKX', 'AKY', 'AKZ', 'ALA', 'ALB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL', 'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ALR', 'ALS', 'ALT', 'ALU', 'ALV', 'ALW', 'ALX', 'ALY', 'ALZ', 'AMA', 'AMB', 'AMC', 'AMD', 'AME', 'AMF', 'AMG', 'AMH', 'AMI', 'AMJ', 'AMK', 'AML', 'AMM', 'AMN', 'AMO', 'AMP', 'AMQ', 'AMR', 'AMS', 'AMT', 'AMU', 'AMV', 'AMW', 'AMX', 'AMY', 'AMZ', 'ANA', 'ANB', 'ANC', 'AND', 'ANE', 'ANF', 'ANG', 'ANH', 'ANI', 'ANJ', 'ANK', 'ANL', 'ANM', 'ANN', 'ANO', 'ANP', 'ANQ', 'ANR', 'ANS', 'ANT', 'ANU', 'ANV', 'ANW', 'ANX', 'ANY', 'AOA', 'AOD', 'AOE', 'AOF', 'AOG', 'AOH', 'AOI', 'AOJ', 'AOK', 'AOL', 'AOM', 'AON', 'AOO', 'AOP', 'AOQ', 'AOR', 'AOS', 'AOT', 'AOU', 'AOV', 'AOW', 'AOX', 'AOY', 'AOZ', 'AP', 'APA', 'APB', 'APC', 'APD', 'APE', 'APF', 'APG', 'APH', 'API', 'APJ', 'APK', 'APL', 'APM', 'APN', 'APO', 'APP', 'APQ', 'APR', 'APS', 'APT', 'APU', 'APV', 'APW', 'APX', 'APY', 'APZ', 'AQA', 'AQB', 'AQC', 'AQD', 'AQE', 'AQF', 'AQG', 'AQH', 'AQI', 'AQJ', 'AQK', 'AQL', 'AQM', 'AQN', 'AQO', 'AQP', 'AQQ', 'AQR', 'AQS', 'AQT', 'AQU', 'AQV', 'AQW', 'AQX', 'AQY', 'AQZ', 'ARA', 'ARB', 'ARC', 'ARD', 'ARE', 'ARF', 'ARG', 'ARH', 'ARI', 'ARJ', 'ARK', 'ARL', 'ARM', 'ARN', 'ARO', 'ARP', 'ARQ', 'ARR', 'ARS', 'ART', 'ARU', 'ARV', 'ARW', 'ARX', 'ARY', 'ARZ', 'ASA', 'ASB', 'ASC', 'ASD', 'ASE', 'ASF', 'ASG', 'ASH', 'ASI', 'ASJ', 'ASK', 'ASL', 'ASM', 'ASN', 'ASO', 'ASP', 'ASQ', 'ASR', 'ASS', 'AST', 'ASU', 'ASV', 'ASW', 'ASX', 'ASY', 'ASZ', 'ATA', 'ATB', 'ATC', 'ATD', 'ATE', 'ATF', 'ATG', 'ATH', 'ATI', 'ATJ', 'ATK', 'ATL', 'ATM', 'ATN', 'ATO', 'ATP', 'ATQ', 'ATR', 'ATS', 'ATT', 'ATU', 'ATV', 'ATW', 'ATX', 'ATY', 'ATZ', 'AU', 'AUA', 'AUB', 'AUC', 'AUD', 'AUE', 'AUF', 'AUG', 'AUH', 'AUI', 'AUJ', 'AUK', 'AUL', 'AUM', 'AUN', 'AUO', 'AUP', 'AUQ', 'AUR', 'AUS', 'AUT', 'AUU', 'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AV', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE', 'AVF', 'AVG', 'AVH', 'AVI', 'AVJ', 'AVK', 'AVL', 'AVM', 'AVN', 'AVO', 'AVP', 'AVQ', 'AVR', 'AVS', 'AVT', 'AVU', 'AVV', 'AVW', 'AVX', 'AVY', 'AVZ', 'AWA', 'AWB', 'AWC', 'AWD', 'AWE', 'AWF', 'AWG', 'AWH', 'AWI', 'AWJ', 'AWK', 'AWL', 'AWM', 'AWN', 'AWO', 'AWP', 'AWQ', 'AWR', 'AWS', 'AWT', 'AWU', 'AWV', 'AWW', 'AWX', 'AWY', 'AWZ', 'AXA', 'AXB', 'AXC', 'AXD', 'AXE', 'AXF', 'AXG', 'AXH', 'AXI', 'AXJ', 'AXK', 'AXL', 'AXM', 'AXN', 'AXO', 'AXP', 'AXQ', 'AXR', 'AXS', 'AXU', 'BA', 'BC', 'BD', 'BE', 'BH', 'BM', 'BN', 'BO', 'BR', 'BT', 'BTP', 'BW', 'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CBA', 'CBB', 'CD', 'CEC', 'CED', 'CFE', 'CFF', 'CFO', 'CG', 'CH', 'CK', 'CKN', 'CM', 'CMR', 'CN', 'CNO', 'COF', 'CP', 'CR', 'CRN', 'CS', 'CST', 'CT', 'CU', 'CV', 'CW', 'CZ', 'DA', 'DAN', 'DB', 'DI', 'DL', 'DM', 'DQ', 'DR', 'EA', 'EB', 'ED', 'EE', 'EEP', 'EI', 'EN', 'EQ', 'ER', 'ERN', 'ET', 'EX', 'FC', 'FF', 'FI', 'FLW', 'FN', 'FO', 'FS', 'FT', 'FV', 'FX', 'GA', 'GC', 'GD', 'GDN', 'GN', 'HS', 'HWB', 'IA', 'IB', 'ICA', 'ICE', 'ICO', 'II', 'IL', 'INB', 'INN', 'INO', 'IP', 'IS', 'IT', 'IV', 'JB', 'JE', 'LA', 'LAN', 'LAR', 'LB', 'LC', 'LI', 'LO', 'LRC', 'LS', 'MA', 'MB', 'MF', 'MG', 'MH', 'MR', 'MRN', 'MS', 'MSS', 'MWB', 'NA', 'NF', 'OH', 'OI', 'ON', 'OP', 'OR', 'PB', 'PC', 'PD', 'PE', 'PF', 'PI', 'PK', 'PL', 'POR', 'PP', 'PQ', 'PR', 'PS', 'PW', 'PY', 'RA', 'RC', 'RCN', 'RE', 'REN', 'RF', 'RR', 'RT', 'SA', 'SB', 'SD', 'SE', 'SEA', 'SF', 'SH', 'SI', 'SM', 'SN', 'SP', 'SQ', 'SRN', 'SS', 'STA', 'SW', 'SZ', 'TB', 'TCR', 'TE', 'TF', 'TI', 'TIN', 'TL', 'TN', 'TP', 'UAR', 'UC', 'UCN', 'UN', 'UO', 'URI', 'VA', 'VC', 'VGR', 'VM', 'VN', 'VON', 'VOR', 'VP', 'VR', 'VS', 'VT', 'VV', 'WE', 'WM', 'WN', 'WR', 'WS', 'WY', 'XA', 'XC', 'XP', 'ZZZ'))">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:TypeCode">
      <let name="codeValue40" value="."/>
      <assert id="FX-SCH-A-000640" test="string-length($codeValue40)=0 or ($codeValue40 = ('130'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;130&quot;]/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]">
      <assert id="FX-SCH-A-000560" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000561" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000641" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000642" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:TypeCode">
      <let name="codeValue39" value="."/>
      <assert id="FX-SCH-A-000643" test="string-length($codeValue39)=0 or ($codeValue39 = ('50'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;50&quot;]/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]">
      <assert id="FX-SCH-A-000563" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000564" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000283" test="count(ram:Name)&lt;=1">
	Element 'ram:Name' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000284" test="count(ram:AttachmentBinaryObject)&lt;=1">
	Element 'ram:AttachmentBinaryObject' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:AttachmentBinaryObject">
      <assert id="FX-SCH-A-000285" test="@mimeCode">
	Attribute '@mimeCode' is required in this context.</assert>
      <let name="codeValue19" value="@mimeCode"/>
      <assert id="FX-SCH-A-000644" test="string-length($codeValue19)=0 or ($codeValue19 = ('application/json', 'application/pdf', 'application/vnd.oasis.opendocument.spreadsheet', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/xml', 'image/jpeg', 'image/png', 'text/csv', 'text/xml'))">
	Value of '@mimeCode' is not allowed.</assert>
      <assert id="FX-SCH-A-000286" test="@filename">
	Attribute '@filename' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000645" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000646" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:TypeCode">
      <let name="codeValue38" value="."/>
      <assert id="FX-SCH-A-000647" test="string-length($codeValue38)=0 or ($codeValue38 = ('916'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument[ram:TypeCode=&quot;916&quot;]/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <assert id="FX-SCH-A-000319" test="count(ram:DeliveryTypeCode)=1">
	Element 'ram:DeliveryTypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:DeliveryTypeCode">
      <let name="codeValue36" value="."/>
      <assert id="FX-SCH-A-000320" test="string-length($codeValue36)=0 or ($codeValue36 = ('1', '2', 'CFR', 'CIF', 'CIP', 'CPT', 'DAP', 'DDP', 'DPU', 'EXW', 'FAS', 'FCA', 'FOB'))">
	Value of 'ram:DeliveryTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:RelevantTradeLocation/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000648" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      <assert id="FX-SCH-A-000649" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000650" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000321" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000651" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000652" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000653" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000654" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000655" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000656" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000657" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000658" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000659" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000660" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000661" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000662" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000663" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000664" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000665" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000666" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000667" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000668" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000669" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument">
      <assert id="FX-SCH-A-000029" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000670" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000671" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty">
      <assert id="FX-SCH-A-000672" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000673" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000674" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000675" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000676" test="count(ram:SpecifiedTaxRegistration)=1">
	Element 'ram:SpecifiedTaxRegistration' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000677" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000678" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000679" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000680" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000681" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000682" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000683" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000684" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000685" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000686" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000687" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000688" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000689" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000690" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000691" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000692" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000693" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert id="FX-SCH-A-000163" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000030" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000694" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000695" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000419" test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000165" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000166" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000566" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000696" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000289" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000420" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000697" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000422" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000167" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000698" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000699" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000700" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000701" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000702" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000425" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000426" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue34" value="@schemeID"/>
      <assert id="FX-SCH-A-000703" test="string-length($codeValue34)=0 or ($codeValue34 = ('VA'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000168" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000428" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000704" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument">
      <assert id="FX-SCH-A-000430" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000705" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000706" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode">
      <let name="codeValue37" value="."/>
      <assert id="FX-SCH-A-000707" test="string-length($codeValue37)=0 or ($codeValue37 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT', 'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE', 'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP', 'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABY', 'ABZ', 'AC', 'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX', 'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADI', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADT', 'ADU', 'ADV', 'ADW', 'ADX', 'ADY', 'ADZ', 'AE', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AF', 'AFA', 'AFB', 'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM', 'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX', 'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI', 'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT', 'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE', 'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP', 'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB', 'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM', 'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX', 'AIY', 'AIZ', 'AJA', 'AJB', 'AJC', 'AJD', 'AJE', 'AJF', 'AJG', 'AJH', 'AJI', 'AJJ', 'AJK', 'AJL', 'AJM', 'AJN', 'AJO', 'AJP', 'AJQ', 'AJR', 'AJS', 'AJT', 'AJU', 'AJV', 'AJW', 'AJX', 'AJY', 'AJZ', 'AKA', 'AKB', 'AKC', 'AKD', 'AKE', 'AKF', 'AKG', 'AKH', 'AKI', 'AKJ', 'AKK', 'AKL', 'AKM', 'AKN', 'AKO', 'AKP', 'AKQ', 'AKR', 'AKS', 'AKT', 'AKU', 'AKV', 'AKW', 'AKX', 'AKY', 'AKZ', 'ALA', 'ALB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL', 'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ALR', 'ALS', 'ALT', 'ALU', 'ALV', 'ALW', 'ALX', 'ALY', 'ALZ', 'AMA', 'AMB', 'AMC', 'AMD', 'AME', 'AMF', 'AMG', 'AMH', 'AMI', 'AMJ', 'AMK', 'AML', 'AMM', 'AMN', 'AMO', 'AMP', 'AMQ', 'AMR', 'AMS', 'AMT', 'AMU', 'AMV', 'AMW', 'AMX', 'AMY', 'AMZ', 'ANA', 'ANB', 'ANC', 'AND', 'ANE', 'ANF', 'ANG', 'ANH', 'ANI', 'ANJ', 'ANK', 'ANL', 'ANM', 'ANN', 'ANO', 'ANP', 'ANQ', 'ANR', 'ANS', 'ANT', 'ANU', 'ANV', 'ANW', 'ANX', 'ANY', 'AOA', 'AOD', 'AOE', 'AOF', 'AOG', 'AOH', 'AOI', 'AOJ', 'AOK', 'AOL', 'AOM', 'AON', 'AOO', 'AOP', 'AOQ', 'AOR', 'AOS', 'AOT', 'AOU', 'AOV', 'AOW', 'AOX', 'AOY', 'AOZ', 'AP', 'APA', 'APB', 'APC', 'APD', 'APE', 'APF', 'APG', 'APH', 'API', 'APJ', 'APK', 'APL', 'APM', 'APN', 'APO', 'APP', 'APQ', 'APR', 'APS', 'APT', 'APU', 'APV', 'APW', 'APX', 'APY', 'APZ', 'AQA', 'AQB', 'AQC', 'AQD', 'AQE', 'AQF', 'AQG', 'AQH', 'AQI', 'AQJ', 'AQK', 'AQL', 'AQM', 'AQN', 'AQO', 'AQP', 'AQQ', 'AQR', 'AQS', 'AQT', 'AQU', 'AQV', 'AQW', 'AQX', 'AQY', 'AQZ', 'ARA', 'ARB', 'ARC', 'ARD', 'ARE', 'ARF', 'ARG', 'ARH', 'ARI', 'ARJ', 'ARK', 'ARL', 'ARM', 'ARN', 'ARO', 'ARP', 'ARQ', 'ARR', 'ARS', 'ART', 'ARU', 'ARV', 'ARW', 'ARX', 'ARY', 'ARZ', 'ASA', 'ASB', 'ASC', 'ASD', 'ASE', 'ASF', 'ASG', 'ASH', 'ASI', 'ASJ', 'ASK', 'ASL', 'ASM', 'ASN', 'ASO', 'ASP', 'ASQ', 'ASR', 'ASS', 'AST', 'ASU', 'ASV', 'ASW', 'ASX', 'ASY', 'ASZ', 'ATA', 'ATB', 'ATC', 'ATD', 'ATE', 'ATF', 'ATG', 'ATH', 'ATI', 'ATJ', 'ATK', 'ATL', 'ATM', 'ATN', 'ATO', 'ATP', 'ATQ', 'ATR', 'ATS', 'ATT', 'ATU', 'ATV', 'ATW', 'ATX', 'ATY', 'ATZ', 'AU', 'AUA', 'AUB', 'AUC', 'AUD', 'AUE', 'AUF', 'AUG', 'AUH', 'AUI', 'AUJ', 'AUK', 'AUL', 'AUM', 'AUN', 'AUO', 'AUP', 'AUQ', 'AUR', 'AUS', 'AUT', 'AUU', 'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AV', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE', 'AVF', 'AVG', 'AVH', 'AVI', 'AVJ', 'AVK', 'AVL', 'AVM', 'AVN', 'AVO', 'AVP', 'AVQ', 'AVR', 'AVS', 'AVT', 'AVU', 'AVV', 'AVW', 'AVX', 'AVY', 'AVZ', 'AWA', 'AWB', 'AWC', 'AWD', 'AWE', 'AWF', 'AWG', 'AWH', 'AWI', 'AWJ', 'AWK', 'AWL', 'AWM', 'AWN', 'AWO', 'AWP', 'AWQ', 'AWR', 'AWS', 'AWT', 'AWU', 'AWV', 'AWW', 'AWX', 'AWY', 'AWZ', 'AXA', 'AXB', 'AXC', 'AXD', 'AXE', 'AXF', 'AXG', 'AXH', 'AXI', 'AXJ', 'AXK', 'AXL', 'AXM', 'AXN', 'AXO', 'AXP', 'AXQ', 'AXR', 'AXS', 'AXU', 'BA', 'BC', 'BD', 'BE', 'BH', 'BM', 'BN', 'BO', 'BR', 'BT', 'BTP', 'BW', 'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CBA', 'CBB', 'CD', 'CEC', 'CED', 'CFE', 'CFF', 'CFO', 'CG', 'CH', 'CK', 'CKN', 'CM', 'CMR', 'CN', 'CNO', 'COF', 'CONTRAT', 'CP', 'CR', 'CRN', 'CS', 'CST', 'CT', 'CU', 'CV', 'CW', 'CZ', 'DA', 'DAN', 'DB', 'DI', 'DL', 'DM', 'DQ', 'DR', 'EA', 'EB', 'ED', 'EE', 'EEP', 'EI', 'EN', 'EQ', 'ER', 'ERN', 'ET', 'EX', 'FC', 'FF', 'FI', 'FLW', 'FN', 'FO', 'FS', 'FT', 'FV', 'FX', 'GA', 'GC', 'GD', 'GDN', 'GN', 'HS', 'HWB', 'IA', 'IB', 'ICA', 'ICE', 'ICO', 'II', 'IL', 'INB', 'INN', 'INO', 'IP', 'IS', 'IT', 'IV', 'JB', 'JE', 'LA', 'LAN', 'LAR', 'LB', 'LC', 'LI', 'LO', 'LRC', 'LS', 'MA', 'MARCHE', 'MB', 'MF', 'MG', 'MH', 'MR', 'MRN', 'MS', 'MSS', 'MWB', 'NA', 'NF', 'OH', 'OI', 'ON', 'OP', 'OR', 'PB', 'PC', 'PD', 'PE', 'PF', 'PI', 'PK', 'PL', 'POR', 'PP', 'PQ', 'PR', 'PS', 'PW', 'PY', 'RA', 'RC', 'RCN', 'RE', 'REN', 'RF', 'RR', 'RT', 'SA', 'SB', 'SD', 'SE', 'SEA', 'SF', 'SH', 'SI', 'SM', 'SN', 'SP', 'SQ', 'SRN', 'SS', 'STA', 'SW', 'SZ', 'TB', 'TCR', 'TE', 'TF', 'TI', 'TIN', 'TL', 'TN', 'TP', 'UAR', 'UC', 'UCN', 'UN', 'UO', 'URI', 'VA', 'VC', 'VGR', 'VM', 'VN', 'VON', 'VOR', 'VP', 'VR', 'VS', 'VT', 'VV', 'WE', 'WM', 'WN', 'WR', 'WS', 'WY', 'XA', 'XC', 'XP', 'ZZZ'))">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty">
      <assert id="FX-SCH-A-000708" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000709" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000710" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000711" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000712" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000713" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000714" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000715" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000716" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000717" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000718" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000719" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000720" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000721" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000722" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000723" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000724" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000725" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000726" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000727" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000728" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000729" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument">
      <assert id="FX-SCH-A-000730" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000731" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000732" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty">
      <assert id="FX-SCH-A-000733" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000734" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000735" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000736" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000737" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000738" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000739" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000740" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000741" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000742" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000743" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000744" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000745" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000746" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000747" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000748" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000749" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000750" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000751" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000752" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000753" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000754" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument">
      <assert id="FX-SCH-A-000572" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000755" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000756" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty">
      <assert id="FX-SCH-A-000757" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000431" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000758" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000432" test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000759" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000169" test="count(ram:SpecifiedTaxRegistration)=1">
	Element 'ram:SpecifiedTaxRegistration' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000760" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000761" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000762" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000763" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000764" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000433" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000434" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000765" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000766" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000767" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000768" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000769" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000436" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000437" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue35" value="@schemeID"/>
      <assert id="FX-SCH-A-000770" test="string-length($codeValue35)=0 or ($codeValue35 = ('VA'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000771" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000772" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000773" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert id="FX-SCH-A-000409" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000774" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000575" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000032" test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000439" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000033" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000034" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000577" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000775" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000578" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000440" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000776" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000035" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000442" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000777" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000778" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000779" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000780" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000781" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]">
      <assert id="FX-SCH-A-000411" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert id="FX-SCH-A-000037" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert id="FX-SCH-A-000412" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert id="FX-SCH-A-000413" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000445" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000446" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000782" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument">
      <assert id="FX-SCH-A-000783" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000784" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000785" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent">
      <assert id="FX-SCH-A-000171" test="count(ram:OccurrenceDateTime)=1">
	Element 'ram:OccurrenceDateTime' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000448" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000786" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument">
      <assert id="FX-SCH-A-000787" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000788" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000789" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument">
      <assert id="FX-SCH-A-000450" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000790" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000791" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument">
      <assert id="FX-SCH-A-000584" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000792" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000793" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment/ram:SpecifiedLogisticsTransportMovement">
      <assert id="FX-SCH-A-000322" test="count(ram:ModeCode)=1">
	Element 'ram:ModeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment/ram:SpecifiedLogisticsTransportMovement/ram:ModeCode">
      <let name="codeValue41" value="."/>
      <assert id="FX-SCH-A-000346" test="string-length($codeValue41)=0 or ($codeValue41 = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9'))">
	Value of 'ram:ModeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty">
      <assert id="FX-SCH-A-000794" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000795" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000796" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000797" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000798" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000799" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000800" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000801" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000802" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000803" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000804" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000805" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000806" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000807" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000808" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000809" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000810" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000811" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000812" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000813" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000814" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <assert id="FX-SCH-A-000451" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000815" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000816" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000817" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000818" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000819" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000820" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000453" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000821" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000455" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000456" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000822" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000823" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000824" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000825" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000826" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000827" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000828" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000829" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000830" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000831" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty">
      <assert id="FX-SCH-A-000832" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000833" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000834" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000835" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000836" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000837" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000838" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000839" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000840" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000841" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000842" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000843" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000844" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000845" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000846" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000847" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000848" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000849" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000850" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000851" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000852" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert id="FX-SCH-A-000172" test="count(ram:PaymentReference)&lt;=1">
	Element 'ram:PaymentReference' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000038" test="count(ram:InvoiceCurrencyCode)=1">
	Element 'ram:InvoiceCurrencyCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000173" test="count(ram:ApplicableTradeTax)&gt;=1">
	Element 'ram:ApplicableTradeTax' must occur at least 1 times.</assert>
      <assert id="FX-SCH-A-000039" test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">
	Element 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <assert id="FX-SCH-A-000176" test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000458" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000177" test="count(ram:BasisAmount)=1">
	Element 'ram:BasisAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000323" test="count(ram:LineTotalBasisAmount)&lt;=1">
	Element 'ram:LineTotalBasisAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000324" test="count(ram:AllowanceChargeBasisAmount)&lt;=1">
	Element 'ram:AllowanceChargeBasisAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000178" test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000853" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <let name="codeValue27" value="."/>
      <assert id="FX-SCH-A-000854" test="string-length($codeValue27)=0 or ($codeValue27 = ('5', '29', '72'))">
	Value of 'ram:DueDateTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-000855" test="string-length($codeValue25)=0 or ($codeValue25 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:LineTotalBasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate/udt:DateString">
      <assert id="FX-SCH-A-000590" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue44" value="@format"/>
      <assert id="FX-SCH-A-000856" test="string-length($codeValue44)=0 or ($codeValue44 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-000857" test="string-length($codeValue26)=0 or ($codeValue26 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <assert id="FX-SCH-A-000858" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:CompleteDateTime">
      <report test="true()">
	Element 'ram:CompleteDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000460" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000859" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000462" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000860" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert id="FX-SCH-A-000861" test="string-length($codeValue42)=0 or ($codeValue42 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of 'ram:InvoiceCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000465" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000862" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">
      <let name="codeValue51" value="."/>
      <assert id="FX-SCH-A-000863" test="string-length($codeValue51)=0 or ($codeValue51 = ('71', '80', '81', '82', '83', '84', '102', '130', '202', '203', '204', '211', '218', '219', '261', '262', '295', '296', '308', '325', '326', '331', '380', '381', '382', '383', '384', '385', '386', '387', '388', '389', '390', '393', '394', '395', '396', '420', '456', '457', '458', '527', '532', '553', '575', '623', '633', '751', '780', '817', '870', '875', '876', '877', '935'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      <assert id="FX-SCH-A-000864" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000865" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000866" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000867" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000868" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000869" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000870" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000871" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000872" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000873" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000874" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000875" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000876" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000877" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000878" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000879" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000880" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000881" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000882" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000883" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000884" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000885" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      <assert id="FX-SCH-A-000886" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000887" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000888" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000889" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000890" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000891" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000892" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000893" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000894" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000895" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000896" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000897" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000898" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000899" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000900" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000901" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000902" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000903" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000904" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000905" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000906" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000907" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <assert id="FX-SCH-A-000467" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000469" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000908" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000909" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000910" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000911" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000912" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000913" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000470" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000914" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000915" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000916" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000917" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000918" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000919" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000920" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000921" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000922" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000923" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000924" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000925" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000926" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      <assert id="FX-SCH-A-000927" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000928" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000929" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000930" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000931" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000932" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000933" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000934" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000935" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000936" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000937" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000938" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000939" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000940" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000941" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000942" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000943" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-000944" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-000945" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-000946" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-000947" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-000948" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:TypeCode">
      <let name="codeValue52" value="."/>
      <assert id="FX-SCH-A-000949" test="string-length($codeValue52)=0 or ($codeValue52 = ('1', '2', '3', '4', '5', '6', '7'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment">
      <assert id="FX-SCH-A-000325" test="count(ram:IncludedTradeTax)&gt;=1">
	Element 'ram:IncludedTradeTax' must occur at least 1 times.</assert>
      <assert id="FX-SCH-A-000326" test="count(ram:InvoiceSpecifiedReferencedDocument)&lt;=1">
	Element 'ram:InvoiceSpecifiedReferencedDocument' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:FormattedReceivedDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000950" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000951" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax">
      <assert id="FX-SCH-A-000952" test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000953" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000954" test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000955" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-000956" test="string-length($codeValue25)=0 or ($codeValue25 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:IncludedTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-000957" test="string-length($codeValue26)=0 or ($codeValue26 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument">
      <assert id="FX-SCH-A-000958" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-000959" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-000960" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:TypeCode">
      <let name="codeValue53" value="."/>
      <assert id="FX-SCH-A-000961" test="string-length($codeValue53)=0 or ($codeValue53 = ('71', '80', '81', '82', '83', '84', '102', '130', '202', '203', '204', '211', '218', '219', '261', '262', '295', '296', '308', '325', '326', '331', '380', '381', '382', '383', '384', '385', '386', '387', '388', '389', '390', '393', '394', '395', '396', '420', '456', '457', '458', '527', '532', '553', '575', '623', '633', '751', '780', '817', '870', '875', '876', '877', '935'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:InvoiceSpecifiedReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment/ram:PaidAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedFinancialAdjustment">
      <assert id="FX-SCH-A-000383" test="count(ram:Reason)=1">
	Element 'ram:Reason' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000962" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedFinancialAdjustment/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge">
      <assert id="FX-SCH-A-000963" test="count(ram:Description)=1">
	Element 'ram:Description' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000327" test="count(ram:AppliedAmount)=1">
	Element 'ram:AppliedAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000328" test="count(ram:AppliedTradeTax)&gt;=1">
	Element 'ram:AppliedTradeTax' must occur at least 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax">
      <assert id="FX-SCH-A-000964" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000965" test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000329" test="count(ram:RateApplicablePercent)=1">
	Element 'ram:RateApplicablePercent' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000966" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue48" value="."/>
      <assert id="FX-SCH-A-000967" test="string-length($codeValue48)=0 or ($codeValue48 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge/ram:AppliedTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-000968" test="string-length($codeValue26)=0 or ($codeValue26 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert id="FX-SCH-A-000183" test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000184" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000185" test="count(ram:CategoryTradeTax)=1">
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-000969" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <assert id="FX-SCH-A-000473" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000474" test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000970" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-000971" test="string-length($codeValue25)=0 or ($codeValue25 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-000972" test="string-length($codeValue26)=0 or ($codeValue26 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue45" value="."/>
      <assert id="FX-SCH-A-000973" test="string-length($codeValue45)=0 or ($codeValue45 = ('41', '42', '60', '62', '63', '64', '65', '66', '67', '68', '70', '71', '88', '95', '100', '102', '103', '104', '105'))">
	Value of 'ram:ReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert id="FX-SCH-A-000477" test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000478" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000479" test="count(ram:CategoryTradeTax)=1">
	Element 'ram:CategoryTradeTax' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-000974" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <assert id="FX-SCH-A-000480" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000481" test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CalculatedAmount">
      <report test="true()">
	Element 'ram:CalculatedAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-000975" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-000976" test="string-length($codeValue25)=0 or ($codeValue25 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-000977" test="string-length($codeValue26)=0 or ($codeValue26 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[ not(not (@listID)) and  not(@listID=&quot;5153&quot;)]">
      <report test="true()">
	Element variant 'ram:ReasonCode[ not(not (@listID)) and  not(@listID="5153")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[@listID=&quot;5153&quot;]">
      <let name="codeValue47" value="."/>
      <assert id="FX-SCH-A-000390" test="string-length($codeValue47)=0 or ($codeValue47 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD'))">
	Value of 'ram:ReasonCode[@listID="5153"]' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[not (@listID)]">
      <let name="codeValue46" value="."/>
      <assert id="FX-SCH-A-000978" test="string-length($codeValue46)=0 or ($codeValue46 = ('AA', 'AAA', 'AAC', 'AAD', 'AAE', 'AAF', 'AAH', 'AAI', 'AAS', 'AAT', 'AAV', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABF', 'ABK', 'ABL', 'ABN', 'ABR', 'ABS', 'ABT', 'ABU', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACM', 'ACS', 'ADC', 'ADE', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADR', 'ADT', 'ADW', 'ADY', 'ADZ', 'AEA', 'AEB', 'AEC', 'AED', 'AEF', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AJ', 'AU', 'CA', 'CAB', 'CAD', 'CAE', 'CAF', 'CAI', 'CAJ', 'CAK', 'CAL', 'CAM', 'CAN', 'CAO', 'CAP', 'CAQ', 'CAR', 'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CD', 'CG', 'CS', 'CT', 'DAB', 'DAC', 'DAD', 'DAF', 'DAG', 'DAH', 'DAI', 'DAJ', 'DAK', 'DAL', 'DAM', 'DAN', 'DAO', 'DAP', 'DAQ', 'DL', 'EG', 'EP', 'ER', 'FAA', 'FAB', 'FAC', 'FC', 'FH', 'FI', 'GAA', 'HAA', 'HD', 'HH', 'IAA', 'IAB', 'ID', 'IF', 'IR', 'IS', 'KO', 'L1', 'LA', 'LAA', 'LAB', 'LF', 'MAE', 'MI', 'ML', 'NAA', 'OA', 'PA', 'PAA', 'PC', 'PL', 'PRV', 'RAB', 'RAC', 'RAD', 'RAF', 'RE', 'RF', 'RH', 'RV', 'SA', 'SAA', 'SAD', 'SAE', 'SAI', 'SG', 'SH', 'SM', 'SU', 'TAB', 'TAC', 'TT', 'TV', 'V1', 'V2', 'WH', 'XAA', 'YY', 'ZZZ'))">
	Value of 'ram:ReasonCode[not (@listID)]' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms">
      <assert id="FX-SCH-A-000187" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000188" test="count(ram:DirectDebitMandateID)&lt;=1">
	Element 'ram:DirectDebitMandateID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000330" test="count(ram:PartialPaymentAmount)&lt;=1">
	Element 'ram:PartialPaymentAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000331" test="count(ram:PayeeTradeParty)&lt;=1">
	Element 'ram:PayeeTradeParty' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms/ram:ActualDiscountAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentDiscountTerms/ram:BasisDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000979" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000980" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:ActualPenaltyAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000981" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000982" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:ApplicableTradePaymentPenaltyTerms/ram:BasisPeriodMeasure">
      <assert id="FX-SCH-A-000277" test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DirectDebitMandateID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000484" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-000983" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PartialPaymentAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty">
      <assert id="FX-SCH-A-000984" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000985" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000986" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000987" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000988" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-000989" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-000990" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-000991" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-000992" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-000993" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000994" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000995" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-000996" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-000997" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-000998" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000999" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001000" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-001001" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-001002" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-001003" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:PayeeTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-001004" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-001005" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert id="FX-SCH-A-000189" test="count(ram:LineTotalAmount)=1">
	Element 'ram:LineTotalAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000190" test="count(ram:ChargeTotalAmount)&lt;=1">
	Element 'ram:ChargeTotalAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000191" test="count(ram:AllowanceTotalAmount)&lt;=1">
	Element 'ram:AllowanceTotalAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000041" test="count(ram:TaxBasisTotalAmount)=1">
	Element 'ram:TaxBasisTotalAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000042" test="count(ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000192" test="count(ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000290" test="count(ram:RoundingAmount)&lt;=1">
	Element 'ram:RoundingAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000043" test="count(ram:GrandTotalAmount)=1">
	Element 'ram:GrandTotalAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000193" test="count(ram:TotalPrepaidAmount)&lt;=1">
	Element 'ram:TotalPrepaidAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000044" test="count(ram:DuePayableAmount)=1">
	Element 'ram:DuePayableAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]">
      <report test="true()">
	Element variant 'ram:TaxTotalAmount[ not(@currencyID=../../ram:InvoiceCurrencyCode) and  not(@currencyID=../../ram:TaxCurrencyCode)]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:InvoiceCurrencyCode]">
      <let name="codeValue49" value="@currencyID"/>
      <assert id="FX-SCH-A-001006" test="string-length($codeValue49)=0 or ($codeValue49 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID=../../ram:TaxCurrencyCode]">
      <let name="codeValue50" value="@currencyID"/>
      <assert id="FX-SCH-A-001007" test="string-length($codeValue50)=0 or ($codeValue50 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans">
      <assert id="FX-SCH-A-000488" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000291" test="count(ram:Information)&lt;=1">
	Element 'ram:Information' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000194" test="count(ram:PayeePartyCreditorFinancialAccount)&lt;=1">
	Element 'ram:PayeePartyCreditorFinancialAccount' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard">
      <assert id="FX-SCH-A-000608" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:ApplicableTradeSettlementFinancialCard/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:ProprietaryID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution">
      <assert id="FX-SCH-A-000292" test="count(ram:BICID)=1">
	Element 'ram:BICID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeeSpecifiedCreditorFinancialInstitution/ram:BICID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount">
      <assert id="FX-SCH-A-000195" test="count(ram:IBANID)=1">
	Element 'ram:IBANID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerPartyDebtorFinancialAccount/ram:IBANID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayerSpecifiedDebtorFinancialInstitution/ram:BICID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode">
      <let name="codeValue43" value="."/>
      <assert id="FX-SCH-A-001008" test="string-length($codeValue43)=0 or ($codeValue43 = ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '74', '75', '76', '77', '78', '91', '92', '93', '94', '95', '96', '97', '98', 'ZZZ'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:ConversionRateDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-001009" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-001010" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:SourceCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert id="FX-SCH-A-000332" test="string-length($codeValue42)=0 or ($codeValue42 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of 'ram:SourceCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange/ram:TargetCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert id="FX-SCH-A-000333" test="string-length($codeValue42)=0 or ($codeValue42 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of 'ram:TargetCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
      <let name="codeValue42" value="."/>
      <assert id="FX-SCH-A-001011" test="string-length($codeValue42)=0 or ($codeValue42 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of 'ram:TaxCurrencyCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <assert id="FX-SCH-A-000266" test="count(ram:AssociatedDocumentLineDocument)=1">
	Element 'ram:AssociatedDocumentLineDocument' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000267" test="count(ram:SpecifiedTradeProduct)=1">
	Element 'ram:SpecifiedTradeProduct' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument">
      <assert id="FX-SCH-A-000270" test="count(ram:LineID)=1">
	Element 'ram:LineID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote">
      <assert id="FX-SCH-A-001012" test="count(ram:Content)&lt;=1">
	Element 'ram:Content' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001013" test="count(ram:SubjectCode)&lt;=1">
	Element 'ram:SubjectCode' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:ContentCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:IncludedNote/ram:SubjectCode">
      <let name="codeValue5" value="."/>
      <assert id="FX-SCH-A-001014" test="string-length($codeValue5)=0 or ($codeValue5 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT', 'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE', 'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP', 'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABZ', 'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACM', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACS', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX', 'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADH', 'ADI', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADR', 'ADS', 'ADT', 'ADU', 'ADV', 'ADW', 'ADX', 'ADY', 'ADZ', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AFA', 'AFB', 'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM', 'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX', 'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI', 'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT', 'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE', 'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP', 'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHW', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB', 'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM', 'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX', 'AIY', 'AIZ', 'AJA', 'AJB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL', 'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ARR', 'ARS', 'AUT', 'AUU', 'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE', 'AVF', 'BAG', 'BAH', 'BAI', 'BAJ', 'BAK', 'BAL', 'BAM', 'BAN', 'BAO', 'BAP', 'BAQ', 'BAR', 'BAS', 'BAT', 'BAU', 'BAV', 'BAW', 'BAX', 'BAY', 'BAZ', 'BBA', 'BBB', 'BLC', 'BLD', 'BLE', 'BLF', 'BLG', 'BLH', 'BLI', 'BLJ', 'BLK', 'BLL', 'BLM', 'BLN', 'BLO', 'BLP', 'BLQ', 'BLR', 'BLS', 'BLT', 'BLU', 'BLV', 'BLW', 'BLX', 'BLY', 'BLZ', 'BMA', 'BMB', 'BMC', 'BMD', 'BME', 'BMF', 'BMG', 'BMH', 'CCI', 'CCJ', 'CCK', 'CCL', 'CCM', 'CCN', 'CCO', 'CEX', 'CHG', 'CIP', 'CLP', 'CLR', 'COI', 'CUR', 'CUS', 'DAR', 'DCL', 'DEL', 'DIN', 'DOC', 'DUT', 'EUR', 'FBC', 'GBL', 'GEN', 'GS7', 'HAN', 'HAZ', 'ICN', 'IIN', 'IMI', 'IND', 'INS', 'INV', 'IRP', 'ITR', 'ITS', 'LAN', 'LIN', 'LOI', 'MCO', 'MDH', 'MKS', 'ORI', 'OSI', 'PAC', 'PAI', 'PAY', 'PKG', 'PKT', 'PMD', 'PMT', 'PRD', 'PRF', 'PRI', 'PUR', 'QIN', 'QQD', 'QUT', 'RAH', 'REG', 'RET', 'REV', 'RQR', 'SAF', 'SIC', 'SIN', 'SLR', 'SPA', 'SPG', 'SPH', 'SPP', 'SPT', 'SRN', 'SSR', 'SUR', 'TCA', 'TDT', 'TRA', 'TRR', 'TXD', 'WHI', 'ZZZ'))">
	Value of 'ram:SubjectCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusCode">
      <let name="codeValue6" value="."/>
      <assert id="FX-SCH-A-000334" test="string-length($codeValue6)=0 or ($codeValue6 = ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119'))">
	Value of 'ram:LineStatusCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:LineStatusReasonCode">
      <let name="codeValue7" value="."/>
      <assert id="FX-SCH-A-000335" test="string-length($codeValue7)=0 or ($codeValue7 = ('DETAIL', 'GROUP', 'INFORMATION'))">
	Value of 'ram:LineStatusReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:AssociatedDocumentLineDocument/ram:ParentLineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument">
      <assert id="FX-SCH-A-001015" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001016" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001017" test="count(ram:Name)&lt;=1">
	Element 'ram:Name' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001018" test="count(ram:AttachmentBinaryObject)&lt;=1">
	Element 'ram:AttachmentBinaryObject' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject">
      <assert id="FX-SCH-A-001019" test="@mimeCode">
	Attribute '@mimeCode' is required in this context.</assert>
      <let name="codeValue19" value="@mimeCode"/>
      <assert id="FX-SCH-A-001020" test="string-length($codeValue19)=0 or ($codeValue19 = ('application/json', 'application/pdf', 'application/vnd.oasis.opendocument.spreadsheet', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/xml', 'image/jpeg', 'image/png', 'text/csv', 'text/xml'))">
	Value of '@mimeCode' is not allowed.</assert>
      <assert id="FX-SCH-A-001021" test="@filename">
	Attribute '@filename' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001022" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001023" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:ReferenceTypeCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-001024" test="string-length($codeValue20)=0 or ($codeValue20 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT', 'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE', 'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP', 'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABY', 'ABZ', 'AC', 'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX', 'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADI', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADT', 'ADU', 'ADV', 'ADW', 'ADX', 'ADY', 'ADZ', 'AE', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AF', 'AFA', 'AFB', 'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM', 'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX', 'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI', 'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT', 'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE', 'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP', 'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB', 'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM', 'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX', 'AIY', 'AIZ', 'AJA', 'AJB', 'AJC', 'AJD', 'AJE', 'AJF', 'AJG', 'AJH', 'AJI', 'AJJ', 'AJK', 'AJL', 'AJM', 'AJN', 'AJO', 'AJP', 'AJQ', 'AJR', 'AJS', 'AJT', 'AJU', 'AJV', 'AJW', 'AJX', 'AJY', 'AJZ', 'AKA', 'AKB', 'AKC', 'AKD', 'AKE', 'AKF', 'AKG', 'AKH', 'AKI', 'AKJ', 'AKK', 'AKL', 'AKM', 'AKN', 'AKO', 'AKP', 'AKQ', 'AKR', 'AKS', 'AKT', 'AKU', 'AKV', 'AKW', 'AKX', 'AKY', 'AKZ', 'ALA', 'ALB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL', 'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ALR', 'ALS', 'ALT', 'ALU', 'ALV', 'ALW', 'ALX', 'ALY', 'ALZ', 'AMA', 'AMB', 'AMC', 'AMD', 'AME', 'AMF', 'AMG', 'AMH', 'AMI', 'AMJ', 'AMK', 'AML', 'AMM', 'AMN', 'AMO', 'AMP', 'AMQ', 'AMR', 'AMS', 'AMT', 'AMU', 'AMV', 'AMW', 'AMX', 'AMY', 'AMZ', 'ANA', 'ANB', 'ANC', 'AND', 'ANE', 'ANF', 'ANG', 'ANH', 'ANI', 'ANJ', 'ANK', 'ANL', 'ANM', 'ANN', 'ANO', 'ANP', 'ANQ', 'ANR', 'ANS', 'ANT', 'ANU', 'ANV', 'ANW', 'ANX', 'ANY', 'AOA', 'AOD', 'AOE', 'AOF', 'AOG', 'AOH', 'AOI', 'AOJ', 'AOK', 'AOL', 'AOM', 'AON', 'AOO', 'AOP', 'AOQ', 'AOR', 'AOS', 'AOT', 'AOU', 'AOV', 'AOW', 'AOX', 'AOY', 'AOZ', 'AP', 'APA', 'APB', 'APC', 'APD', 'APE', 'APF', 'APG', 'APH', 'API', 'APJ', 'APK', 'APL', 'APM', 'APN', 'APO', 'APP', 'APQ', 'APR', 'APS', 'APT', 'APU', 'APV', 'APW', 'APX', 'APY', 'APZ', 'AQA', 'AQB', 'AQC', 'AQD', 'AQE', 'AQF', 'AQG', 'AQH', 'AQI', 'AQJ', 'AQK', 'AQL', 'AQM', 'AQN', 'AQO', 'AQP', 'AQQ', 'AQR', 'AQS', 'AQT', 'AQU', 'AQV', 'AQW', 'AQX', 'AQY', 'AQZ', 'ARA', 'ARB', 'ARC', 'ARD', 'ARE', 'ARF', 'ARG', 'ARH', 'ARI', 'ARJ', 'ARK', 'ARL', 'ARM', 'ARN', 'ARO', 'ARP', 'ARQ', 'ARR', 'ARS', 'ART', 'ARU', 'ARV', 'ARW', 'ARX', 'ARY', 'ARZ', 'ASA', 'ASB', 'ASC', 'ASD', 'ASE', 'ASF', 'ASG', 'ASH', 'ASI', 'ASJ', 'ASK', 'ASL', 'ASM', 'ASN', 'ASO', 'ASP', 'ASQ', 'ASR', 'ASS', 'AST', 'ASU', 'ASV', 'ASW', 'ASX', 'ASY', 'ASZ', 'ATA', 'ATB', 'ATC', 'ATD', 'ATE', 'ATF', 'ATG', 'ATH', 'ATI', 'ATJ', 'ATK', 'ATL', 'ATM', 'ATN', 'ATO', 'ATP', 'ATQ', 'ATR', 'ATS', 'ATT', 'ATU', 'ATV', 'ATW', 'ATX', 'ATY', 'ATZ', 'AU', 'AUA', 'AUB', 'AUC', 'AUD', 'AUE', 'AUF', 'AUG', 'AUH', 'AUI', 'AUJ', 'AUK', 'AUL', 'AUM', 'AUN', 'AUO', 'AUP', 'AUQ', 'AUR', 'AUS', 'AUT', 'AUU', 'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AV', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE', 'AVF', 'AVG', 'AVH', 'AVI', 'AVJ', 'AVK', 'AVL', 'AVM', 'AVN', 'AVO', 'AVP', 'AVQ', 'AVR', 'AVS', 'AVT', 'AVU', 'AVV', 'AVW', 'AVX', 'AVY', 'AVZ', 'AWA', 'AWB', 'AWC', 'AWD', 'AWE', 'AWF', 'AWG', 'AWH', 'AWI', 'AWJ', 'AWK', 'AWL', 'AWM', 'AWN', 'AWO', 'AWP', 'AWQ', 'AWR', 'AWS', 'AWT', 'AWU', 'AWV', 'AWW', 'AWX', 'AWY', 'AWZ', 'AXA', 'AXB', 'AXC', 'AXD', 'AXE', 'AXF', 'AXG', 'AXH', 'AXI', 'AXJ', 'AXK', 'AXL', 'AXM', 'AXN', 'AXO', 'AXP', 'AXQ', 'AXR', 'AXS', 'AXU', 'BA', 'BC', 'BD', 'BE', 'BH', 'BM', 'BN', 'BO', 'BR', 'BT', 'BTP', 'BW', 'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CBA', 'CBB', 'CD', 'CEC', 'CED', 'CFE', 'CFF', 'CFO', 'CG', 'CH', 'CK', 'CKN', 'CM', 'CMR', 'CN', 'CNO', 'COF', 'CP', 'CR', 'CRN', 'CS', 'CST', 'CT', 'CU', 'CV', 'CW', 'CZ', 'DA', 'DAN', 'DB', 'DI', 'DL', 'DM', 'DQ', 'DR', 'EA', 'EB', 'ED', 'EE', 'EEP', 'EI', 'EN', 'EQ', 'ER', 'ERN', 'ET', 'EX', 'FC', 'FF', 'FI', 'FLW', 'FN', 'FO', 'FS', 'FT', 'FV', 'FX', 'GA', 'GC', 'GD', 'GDN', 'GN', 'HS', 'HWB', 'IA', 'IB', 'ICA', 'ICE', 'ICO', 'II', 'IL', 'INB', 'INN', 'INO', 'IP', 'IS', 'IT', 'IV', 'JB', 'JE', 'LA', 'LAN', 'LAR', 'LB', 'LC', 'LI', 'LO', 'LRC', 'LS', 'MA', 'MB', 'MF', 'MG', 'MH', 'MR', 'MRN', 'MS', 'MSS', 'MWB', 'NA', 'NF', 'OH', 'OI', 'ON', 'OP', 'OR', 'PB', 'PC', 'PD', 'PE', 'PF', 'PI', 'PK', 'PL', 'POR', 'PP', 'PQ', 'PR', 'PS', 'PW', 'PY', 'RA', 'RC', 'RCN', 'RE', 'REN', 'RF', 'RR', 'RT', 'SA', 'SB', 'SD', 'SE', 'SEA', 'SF', 'SH', 'SI', 'SM', 'SN', 'SP', 'SQ', 'SRN', 'SS', 'STA', 'SW', 'SZ', 'TB', 'TCR', 'TE', 'TF', 'TI', 'TIN', 'TL', 'TN', 'TP', 'UAR', 'UC', 'UCN', 'UN', 'UO', 'URI', 'VA', 'VC', 'VGR', 'VM', 'VN', 'VON', 'VOR', 'VP', 'VR', 'VS', 'VT', 'VV', 'WE', 'WM', 'WN', 'WR', 'WS', 'WY', 'XA', 'XC', 'XP', 'ZZZ'))">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:TypeCode">
      <let name="codeValue18" value="."/>
      <assert id="FX-SCH-A-001025" test="string-length($codeValue18)=0 or ($codeValue18 = ('50', '130', '916'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <assert id="FX-SCH-A-001026" test="count(ram:DeliveryTypeCode)=1">
	Element 'ram:DeliveryTypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:DeliveryTypeCode">
      <let name="codeValue16" value="."/>
      <assert id="FX-SCH-A-001027" test="string-length($codeValue16)=0 or ($codeValue16 = ('1', '2', 'CFR', 'CIF', 'CIP', 'CPT', 'DAP', 'DDP', 'DPU', 'EXW', 'FAS', 'FCA', 'FOB'))">
	Value of 'ram:DeliveryTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ApplicableTradeDeliveryTerms/ram:RelevantTradeLocation/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001028" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001029" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001030" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001031" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001032" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice">
      <assert id="FX-SCH-A-000273" test="count(ram:ChargeAmount)=1">
	Element 'ram:ChargeAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:AppliedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert id="FX-SCH-A-000530" test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000531" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue21" value="."/>
      <assert id="FX-SCH-A-001033" test="string-length($codeValue21)=0 or ($codeValue21 = ('41', '42', '60', '62', '63', '64', '65', '66', '67', '68', '70', '71', '88', '95', '100', '102', '103', '104', '105'))">
	Value of 'ram:ReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert id="FX-SCH-A-001034" test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001035" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[ not(@listID=&quot;5153&quot;) and  not(not (@listID))]">
      <report test="true()">
	Element variant 'ram:ReasonCode[ not(@listID="5153") and  not(not (@listID))]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[@listID=&quot;5153&quot;]">
      <let name="codeValue22" value="."/>
      <assert id="FX-SCH-A-001036" test="string-length($codeValue22)=0 or ($codeValue22 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:ReasonCode[@listID="5153"]' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[not (@listID)]">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001037" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:IncludedTradeTax">
      <report test="true()">
	Element 'ram:IncludedTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty">
      <assert id="FX-SCH-A-001038" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001039" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001040" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001041" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001042" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=1">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-001043" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-001044" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-001045" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-001046" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-001047" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-001048" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001049" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001050" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-001051" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]">
      <assert id="FX-SCH-A-001052" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert id="FX-SCH-A-001053" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert id="FX-SCH-A-001054" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert id="FX-SCH-A-001055" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-001056" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ItemSellerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-001057" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-001058" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice">
      <assert id="FX-SCH-A-000532" test="count(ram:ChargeAmount)=1">
	Element 'ram:ChargeAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000336" test="count(ram:IncludedTradeTax)&lt;=1">
	Element 'ram:IncludedTradeTax' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:AppliedTradeAllowanceCharge">
      <report test="true()">
	Element 'ram:AppliedTradeAllowanceCharge' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001059" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax">
      <assert id="FX-SCH-A-001060" test="count(ram:CalculatedAmount)=1">
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001061" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001062" test="count(ram:CategoryCode)=1">
	Element 'ram:CategoryCode' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001063" test="count(ram:RateApplicablePercent)=1">
	Element 'ram:RateApplicablePercent' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-001064" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:DueDateTypeCode">
      <report test="true()">
	Element 'ram:DueDateTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-001065" test="string-length($codeValue25)=0 or ($codeValue25 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:IncludedTradeTax/ram:TypeCode">
      <let name="codeValue23" value="."/>
      <assert id="FX-SCH-A-001066" test="string-length($codeValue23)=0 or ($codeValue23 = ('VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001067" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001068" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001069" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001070" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:SellerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001071" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001072" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent">
      <assert id="FX-SCH-A-001073" test="count(ram:OccurrenceDateTime)=1">
	Element 'ram:OccurrenceDateTime' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-001074" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-001075" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001076" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ChargeFreeQuantity">
      <assert id="FX-SCH-A-001077" test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001078" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001079" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001080" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DeliveryNoteReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001081" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001082" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:PackageQuantity">
      <assert id="FX-SCH-A-001083" test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001084" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:PerPackageUnitQuantity">
      <assert id="FX-SCH-A-001085" test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001086" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001087" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001088" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty">
      <assert id="FX-SCH-A-001089" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001090" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001091" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001092" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-001093" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-001094" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-001095" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-001096" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-001097" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-001098" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001099" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001100" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <assert id="FX-SCH-A-001101" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-001102" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-001103" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-001104" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-001105" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-001106" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-001107" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty">
      <assert id="FX-SCH-A-001108" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001109" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001110" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001111" test="count(ram:SpecifiedTaxRegistration)&lt;=1">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-001112" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-001113" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-001114" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-001115" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-001116" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-001117" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001118" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001119" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-001120" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration">
      <assert id="FX-SCH-A-001121" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert id="FX-SCH-A-001122" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-001123" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-001124" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-001125" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement">
      <assert id="FX-SCH-A-000337" test="count(ram:InvoiceReferencedDocument)&lt;=1">
	Element 'ram:InvoiceReferencedDocument' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument">
      <assert id="FX-SCH-A-000615" test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000616" test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime">
      <report test="true()">
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:ReferenceTypeCode">
      <let name="codeValue20" value="."/>
      <assert id="FX-SCH-A-001126" test="string-length($codeValue20)=0 or ($codeValue20 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAN', 'AAO', 'AAP', 'AAQ', 'AAR', 'AAS', 'AAT', 'AAU', 'AAV', 'AAW', 'AAX', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABE', 'ABF', 'ABG', 'ABH', 'ABI', 'ABJ', 'ABK', 'ABL', 'ABM', 'ABN', 'ABO', 'ABP', 'ABQ', 'ABR', 'ABS', 'ABT', 'ABU', 'ABV', 'ABW', 'ABX', 'ABY', 'ABZ', 'AC', 'ACA', 'ACB', 'ACC', 'ACD', 'ACE', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACN', 'ACO', 'ACP', 'ACQ', 'ACR', 'ACT', 'ACU', 'ACV', 'ACW', 'ACX', 'ACY', 'ACZ', 'ADA', 'ADB', 'ADC', 'ADD', 'ADE', 'ADF', 'ADG', 'ADI', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADT', 'ADU', 'ADV', 'ADW', 'ADX', 'ADY', 'ADZ', 'AE', 'AEA', 'AEB', 'AEC', 'AED', 'AEE', 'AEF', 'AEG', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AEQ', 'AER', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AF', 'AFA', 'AFB', 'AFC', 'AFD', 'AFE', 'AFF', 'AFG', 'AFH', 'AFI', 'AFJ', 'AFK', 'AFL', 'AFM', 'AFN', 'AFO', 'AFP', 'AFQ', 'AFR', 'AFS', 'AFT', 'AFU', 'AFV', 'AFW', 'AFX', 'AFY', 'AFZ', 'AGA', 'AGB', 'AGC', 'AGD', 'AGE', 'AGF', 'AGG', 'AGH', 'AGI', 'AGJ', 'AGK', 'AGL', 'AGM', 'AGN', 'AGO', 'AGP', 'AGQ', 'AGR', 'AGS', 'AGT', 'AGU', 'AGV', 'AGW', 'AGX', 'AGY', 'AGZ', 'AHA', 'AHB', 'AHC', 'AHD', 'AHE', 'AHF', 'AHG', 'AHH', 'AHI', 'AHJ', 'AHK', 'AHL', 'AHM', 'AHN', 'AHO', 'AHP', 'AHQ', 'AHR', 'AHS', 'AHT', 'AHU', 'AHV', 'AHX', 'AHY', 'AHZ', 'AIA', 'AIB', 'AIC', 'AID', 'AIE', 'AIF', 'AIG', 'AIH', 'AII', 'AIJ', 'AIK', 'AIL', 'AIM', 'AIN', 'AIO', 'AIP', 'AIQ', 'AIR', 'AIS', 'AIT', 'AIU', 'AIV', 'AIW', 'AIX', 'AIY', 'AIZ', 'AJA', 'AJB', 'AJC', 'AJD', 'AJE', 'AJF', 'AJG', 'AJH', 'AJI', 'AJJ', 'AJK', 'AJL', 'AJM', 'AJN', 'AJO', 'AJP', 'AJQ', 'AJR', 'AJS', 'AJT', 'AJU', 'AJV', 'AJW', 'AJX', 'AJY', 'AJZ', 'AKA', 'AKB', 'AKC', 'AKD', 'AKE', 'AKF', 'AKG', 'AKH', 'AKI', 'AKJ', 'AKK', 'AKL', 'AKM', 'AKN', 'AKO', 'AKP', 'AKQ', 'AKR', 'AKS', 'AKT', 'AKU', 'AKV', 'AKW', 'AKX', 'AKY', 'AKZ', 'ALA', 'ALB', 'ALC', 'ALD', 'ALE', 'ALF', 'ALG', 'ALH', 'ALI', 'ALJ', 'ALK', 'ALL', 'ALM', 'ALN', 'ALO', 'ALP', 'ALQ', 'ALR', 'ALS', 'ALT', 'ALU', 'ALV', 'ALW', 'ALX', 'ALY', 'ALZ', 'AMA', 'AMB', 'AMC', 'AMD', 'AME', 'AMF', 'AMG', 'AMH', 'AMI', 'AMJ', 'AMK', 'AML', 'AMM', 'AMN', 'AMO', 'AMP', 'AMQ', 'AMR', 'AMS', 'AMT', 'AMU', 'AMV', 'AMW', 'AMX', 'AMY', 'AMZ', 'ANA', 'ANB', 'ANC', 'AND', 'ANE', 'ANF', 'ANG', 'ANH', 'ANI', 'ANJ', 'ANK', 'ANL', 'ANM', 'ANN', 'ANO', 'ANP', 'ANQ', 'ANR', 'ANS', 'ANT', 'ANU', 'ANV', 'ANW', 'ANX', 'ANY', 'AOA', 'AOD', 'AOE', 'AOF', 'AOG', 'AOH', 'AOI', 'AOJ', 'AOK', 'AOL', 'AOM', 'AON', 'AOO', 'AOP', 'AOQ', 'AOR', 'AOS', 'AOT', 'AOU', 'AOV', 'AOW', 'AOX', 'AOY', 'AOZ', 'AP', 'APA', 'APB', 'APC', 'APD', 'APE', 'APF', 'APG', 'APH', 'API', 'APJ', 'APK', 'APL', 'APM', 'APN', 'APO', 'APP', 'APQ', 'APR', 'APS', 'APT', 'APU', 'APV', 'APW', 'APX', 'APY', 'APZ', 'AQA', 'AQB', 'AQC', 'AQD', 'AQE', 'AQF', 'AQG', 'AQH', 'AQI', 'AQJ', 'AQK', 'AQL', 'AQM', 'AQN', 'AQO', 'AQP', 'AQQ', 'AQR', 'AQS', 'AQT', 'AQU', 'AQV', 'AQW', 'AQX', 'AQY', 'AQZ', 'ARA', 'ARB', 'ARC', 'ARD', 'ARE', 'ARF', 'ARG', 'ARH', 'ARI', 'ARJ', 'ARK', 'ARL', 'ARM', 'ARN', 'ARO', 'ARP', 'ARQ', 'ARR', 'ARS', 'ART', 'ARU', 'ARV', 'ARW', 'ARX', 'ARY', 'ARZ', 'ASA', 'ASB', 'ASC', 'ASD', 'ASE', 'ASF', 'ASG', 'ASH', 'ASI', 'ASJ', 'ASK', 'ASL', 'ASM', 'ASN', 'ASO', 'ASP', 'ASQ', 'ASR', 'ASS', 'AST', 'ASU', 'ASV', 'ASW', 'ASX', 'ASY', 'ASZ', 'ATA', 'ATB', 'ATC', 'ATD', 'ATE', 'ATF', 'ATG', 'ATH', 'ATI', 'ATJ', 'ATK', 'ATL', 'ATM', 'ATN', 'ATO', 'ATP', 'ATQ', 'ATR', 'ATS', 'ATT', 'ATU', 'ATV', 'ATW', 'ATX', 'ATY', 'ATZ', 'AU', 'AUA', 'AUB', 'AUC', 'AUD', 'AUE', 'AUF', 'AUG', 'AUH', 'AUI', 'AUJ', 'AUK', 'AUL', 'AUM', 'AUN', 'AUO', 'AUP', 'AUQ', 'AUR', 'AUS', 'AUT', 'AUU', 'AUV', 'AUW', 'AUX', 'AUY', 'AUZ', 'AV', 'AVA', 'AVB', 'AVC', 'AVD', 'AVE', 'AVF', 'AVG', 'AVH', 'AVI', 'AVJ', 'AVK', 'AVL', 'AVM', 'AVN', 'AVO', 'AVP', 'AVQ', 'AVR', 'AVS', 'AVT', 'AVU', 'AVV', 'AVW', 'AVX', 'AVY', 'AVZ', 'AWA', 'AWB', 'AWC', 'AWD', 'AWE', 'AWF', 'AWG', 'AWH', 'AWI', 'AWJ', 'AWK', 'AWL', 'AWM', 'AWN', 'AWO', 'AWP', 'AWQ', 'AWR', 'AWS', 'AWT', 'AWU', 'AWV', 'AWW', 'AWX', 'AWY', 'AWZ', 'AXA', 'AXB', 'AXC', 'AXD', 'AXE', 'AXF', 'AXG', 'AXH', 'AXI', 'AXJ', 'AXK', 'AXL', 'AXM', 'AXN', 'AXO', 'AXP', 'AXQ', 'AXR', 'AXS', 'AXU', 'BA', 'BC', 'BD', 'BE', 'BH', 'BM', 'BN', 'BO', 'BR', 'BT', 'BTP', 'BW', 'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CBA', 'CBB', 'CD', 'CEC', 'CED', 'CFE', 'CFF', 'CFO', 'CG', 'CH', 'CK', 'CKN', 'CM', 'CMR', 'CN', 'CNO', 'COF', 'CP', 'CR', 'CRN', 'CS', 'CST', 'CT', 'CU', 'CV', 'CW', 'CZ', 'DA', 'DAN', 'DB', 'DI', 'DL', 'DM', 'DQ', 'DR', 'EA', 'EB', 'ED', 'EE', 'EEP', 'EI', 'EN', 'EQ', 'ER', 'ERN', 'ET', 'EX', 'FC', 'FF', 'FI', 'FLW', 'FN', 'FO', 'FS', 'FT', 'FV', 'FX', 'GA', 'GC', 'GD', 'GDN', 'GN', 'HS', 'HWB', 'IA', 'IB', 'ICA', 'ICE', 'ICO', 'II', 'IL', 'INB', 'INN', 'INO', 'IP', 'IS', 'IT', 'IV', 'JB', 'JE', 'LA', 'LAN', 'LAR', 'LB', 'LC', 'LI', 'LO', 'LRC', 'LS', 'MA', 'MB', 'MF', 'MG', 'MH', 'MR', 'MRN', 'MS', 'MSS', 'MWB', 'NA', 'NF', 'OH', 'OI', 'ON', 'OP', 'OR', 'PB', 'PC', 'PD', 'PE', 'PF', 'PI', 'PK', 'PL', 'POR', 'PP', 'PQ', 'PR', 'PS', 'PW', 'PY', 'RA', 'RC', 'RCN', 'RE', 'REN', 'RF', 'RR', 'RT', 'SA', 'SB', 'SD', 'SE', 'SEA', 'SF', 'SH', 'SI', 'SM', 'SN', 'SP', 'SQ', 'SRN', 'SS', 'STA', 'SW', 'SZ', 'TB', 'TCR', 'TE', 'TF', 'TI', 'TIN', 'TL', 'TN', 'TP', 'UAR', 'UC', 'UCN', 'UN', 'UO', 'URI', 'VA', 'VC', 'VGR', 'VM', 'VN', 'VON', 'VOR', 'VP', 'VR', 'VS', 'VT', 'VV', 'WE', 'WM', 'WN', 'WR', 'WS', 'WY', 'XA', 'XC', 'XP', 'ZZZ'))">
	Value of 'ram:ReferenceTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:TypeCode">
      <let name="codeValue18" value="."/>
      <assert id="FX-SCH-A-001127" test="string-length($codeValue18)=0 or ($codeValue18 = ('50', '130', '916'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:AdditionalReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax">
      <assert id="FX-SCH-A-000338" test="count(ram:CalculatedAmount)&lt;=1">
	Element 'ram:CalculatedAmount' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:AllowanceChargeBasisAmount">
      <report test="true()">
	Element 'ram:AllowanceChargeBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:BasisAmount">
      <report test="true()">
	Element 'ram:BasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CalculatedAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode">
      <let name="codeValue24" value="."/>
      <assert id="FX-SCH-A-001128" test="string-length($codeValue24)=0 or ($codeValue24 = ('AE', 'B', 'E', 'G', 'K', 'L', 'M', 'O', 'S', 'Z'))">
	Value of 'ram:CategoryCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode">
      <let name="codeValue27" value="."/>
      <assert id="FX-SCH-A-001129" test="string-length($codeValue27)=0 or ($codeValue27 = ('5', '29', '72'))">
	Value of 'ram:DueDateTypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode">
      <let name="codeValue25" value="."/>
      <assert id="FX-SCH-A-001130" test="string-length($codeValue25)=0 or ($codeValue25 = ('VATEX-EU-132', 'VATEX-EU-132-1A', 'VATEX-EU-132-1B', 'VATEX-EU-132-1C', 'VATEX-EU-132-1D', 'VATEX-EU-132-1E', 'VATEX-EU-132-1F', 'VATEX-EU-132-1G', 'VATEX-EU-132-1H', 'VATEX-EU-132-1I', 'VATEX-EU-132-1J', 'VATEX-EU-132-1K', 'VATEX-EU-132-1L', 'VATEX-EU-132-1M', 'VATEX-EU-132-1N', 'VATEX-EU-132-1O', 'VATEX-EU-132-1P', 'VATEX-EU-132-1Q', 'VATEX-EU-135-1', 'VATEX-EU-143', 'VATEX-EU-143-1A', 'VATEX-EU-143-1B', 'VATEX-EU-143-1C', 'VATEX-EU-143-1D', 'VATEX-EU-143-1E', 'VATEX-EU-143-1F', 'VATEX-EU-143-1FA', 'VATEX-EU-143-1G', 'VATEX-EU-143-1H', 'VATEX-EU-143-1I', 'VATEX-EU-143-1J', 'VATEX-EU-143-1K', 'VATEX-EU-143-1L', 'VATEX-EU-144', 'VATEX-EU-146-1E', 'VATEX-EU-148', 'VATEX-EU-148-A', 'VATEX-EU-148-B', 'VATEX-EU-148-C', 'VATEX-EU-148-D', 'VATEX-EU-148-E', 'VATEX-EU-148-F', 'VATEX-EU-148-G', 'VATEX-EU-151', 'VATEX-EU-151-1A', 'VATEX-EU-151-1AA', 'VATEX-EU-151-1B', 'VATEX-EU-151-1C', 'VATEX-EU-151-1D', 'VATEX-EU-151-1E', 'VATEX-EU-153', 'VATEX-EU-159', 'VATEX-EU-309', 'VATEX-EU-79-C', 'VATEX-EU-AE', 'VATEX-EU-D', 'VATEX-EU-F', 'VATEX-EU-G', 'VATEX-EU-I', 'VATEX-EU-IC', 'VATEX-EU-J', 'VATEX-EU-O', 'VATEX-FR-298SEXDECIESA', 'VATEX-FR-AE', 'VATEX-FR-CGI261-1', 'VATEX-FR-CGI261-2', 'VATEX-FR-CGI261-3', 'VATEX-FR-CGI261-4', 'VATEX-FR-CGI261-5', 'VATEX-FR-CGI261-7', 'VATEX-FR-CGI261-8', 'VATEX-FR-CGI261A', 'VATEX-FR-CGI261B', 'VATEX-FR-CGI261C-1', 'VATEX-FR-CGI261C-2', 'VATEX-FR-CGI261C-3', 'VATEX-FR-CGI261D-1', 'VATEX-FR-CGI261D-1BIS', 'VATEX-FR-CGI261D-2', 'VATEX-FR-CGI261D-3', 'VATEX-FR-CGI261D-4', 'VATEX-FR-CGI261E-1', 'VATEX-FR-CGI261E-2', 'VATEX-FR-CGI275', 'VATEX-FR-CGI277A', 'VATEX-FR-CGI295', 'VATEX-FR-CNWVAT', 'VATEX-FR-FRANCHISE'))">
	Value of 'ram:ExemptionReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:LineTotalBasisAmount">
      <report test="true()">
	Element 'ram:LineTotalBasisAmount' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TaxPointDate">
      <report test="true()">
	Element 'ram:TaxPointDate' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode">
      <let name="codeValue26" value="."/>
      <assert id="FX-SCH-A-001131" test="string-length($codeValue26)=0 or ($codeValue26 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:CompleteDateTime">
      <report test="true()">
	Element 'ram:CompleteDateTime' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000539" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-001132" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString">
      <assert id="FX-SCH-A-000541" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue3" value="@format"/>
      <assert id="FX-SCH-A-001133" test="string-length($codeValue3)=0 or ($codeValue3 = ('102'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString">
      <assert id="FX-SCH-A-001134" test="@format">
	Attribute '@format' is required in this context.</assert>
      <let name="codeValue17" value="@format"/>
      <assert id="FX-SCH-A-001135" test="string-length($codeValue17)=0 or ($codeValue17 = ('102', '205'))">
	Value of '@format' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:LineID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:TypeCode">
      <let name="codeValue33" value="."/>
      <assert id="FX-SCH-A-001136" test="string-length($codeValue33)=0 or ($codeValue33 = ('71', '80', '81', '82', '83', '84', '102', '130', '202', '203', '204', '211', '218', '219', '261', '262', '295', '296', '308', '325', '326', '331', '380', '381', '382', '383', '384', '385', '386', '387', '388', '389', '390', '393', '394', '395', '396', '420', '456', '457', '458', '527', '532', '553', '575', '623', '633', '751', '780', '817', '870', '875', '876', '877', '935'))">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator=&quot;false&quot;) and  not(ram:ChargeIndicator/udt:Indicator=&quot;true&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTradeAllowanceCharge[ not(ram:ChargeIndicator/udt:Indicator="false") and  not(ram:ChargeIndicator/udt:Indicator="true")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]">
      <assert id="FX-SCH-A-000543" test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000544" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:ReasonCode">
      <let name="codeValue28" value="."/>
      <assert id="FX-SCH-A-001137" test="string-length($codeValue28)=0 or ($codeValue28 = ('41', '42', '60', '62', '63', '64', '65', '66', '67', '68', '70', '71', '88', '95', '100', '102', '103', '104', '105'))">
	Value of 'ram:ReasonCode' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;false&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]">
      <assert id="FX-SCH-A-000546" test="count(ram:ChargeIndicator)=1">
	Element 'ram:ChargeIndicator' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000547" test="count(ram:ActualAmount)=1">
	Element 'ram:ActualAmount' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ActualAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:BasisQuantity">
      <report test="true()">
	Element 'ram:BasisQuantity' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:CategoryTradeTax">
      <report test="true()">
	Element 'ram:CategoryTradeTax' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[ not(not (@listID)) and  not(@listID=&quot;5153&quot;)]">
      <report test="true()">
	Element variant 'ram:ReasonCode[ not(not (@listID)) and  not(@listID="5153")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[@listID=&quot;5153&quot;]">
      <let name="codeValue30" value="."/>
      <assert id="FX-SCH-A-001138" test="string-length($codeValue30)=0 or ($codeValue30 = ('AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD', 'VAT', 'AAA', 'AAB', 'AAC', 'AAD', 'AAE', 'AAF', 'AAG', 'AAH', 'AAI', 'AAJ', 'AAK', 'AAL', 'AAM', 'AAO', 'AAP', 'ADD', 'BOL', 'CAP', 'CAR', 'COC', 'CST', 'CUD', 'CVD', 'ENV', 'EXC', 'EXP', 'FET', 'FRE', 'GCN', 'GST', 'ILL', 'IMP', 'IND', 'LAC', 'LCN', 'LDP', 'LOC', 'LST', 'MCA', 'MCD', 'OTH', 'PDB', 'PDC', 'PRF', 'SCN', 'SSS', 'STT', 'SUP', 'SUR', 'SWT', 'TAC', 'TOT', 'TOX', 'TTA', 'VAD'))">
	Value of 'ram:ReasonCode[@listID="5153"]' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:ReasonCode[not (@listID)]">
      <let name="codeValue29" value="."/>
      <assert id="FX-SCH-A-001139" test="string-length($codeValue29)=0 or ($codeValue29 = ('AA', 'AAA', 'AAC', 'AAD', 'AAE', 'AAF', 'AAH', 'AAI', 'AAS', 'AAT', 'AAV', 'AAY', 'AAZ', 'ABA', 'ABB', 'ABC', 'ABD', 'ABF', 'ABK', 'ABL', 'ABN', 'ABR', 'ABS', 'ABT', 'ABU', 'ACF', 'ACG', 'ACH', 'ACI', 'ACJ', 'ACK', 'ACL', 'ACM', 'ACS', 'ADC', 'ADE', 'ADJ', 'ADK', 'ADL', 'ADM', 'ADN', 'ADO', 'ADP', 'ADQ', 'ADR', 'ADT', 'ADW', 'ADY', 'ADZ', 'AEA', 'AEB', 'AEC', 'AED', 'AEF', 'AEH', 'AEI', 'AEJ', 'AEK', 'AEL', 'AEM', 'AEN', 'AEO', 'AEP', 'AES', 'AET', 'AEU', 'AEV', 'AEW', 'AEX', 'AEY', 'AEZ', 'AJ', 'AU', 'CA', 'CAB', 'CAD', 'CAE', 'CAF', 'CAI', 'CAJ', 'CAK', 'CAL', 'CAM', 'CAN', 'CAO', 'CAP', 'CAQ', 'CAR', 'CAS', 'CAT', 'CAU', 'CAV', 'CAW', 'CAX', 'CAY', 'CAZ', 'CD', 'CG', 'CS', 'CT', 'DAB', 'DAC', 'DAD', 'DAF', 'DAG', 'DAH', 'DAI', 'DAJ', 'DAK', 'DAL', 'DAM', 'DAN', 'DAO', 'DAP', 'DAQ', 'DL', 'EG', 'EP', 'ER', 'FAA', 'FAB', 'FAC', 'FC', 'FH', 'FI', 'GAA', 'HAA', 'HD', 'HH', 'IAA', 'IAB', 'ID', 'IF', 'IR', 'IS', 'KO', 'L1', 'LA', 'LAA', 'LAB', 'LF', 'MAE', 'MI', 'ML', 'NAA', 'OA', 'PA', 'PAA', 'PC', 'PL', 'PRV', 'RAB', 'RAC', 'RAD', 'RAF', 'RE', 'RF', 'RH', 'RV', 'SA', 'SAA', 'SAD', 'SAE', 'SAI', 'SG', 'SH', 'SM', 'SU', 'TAB', 'TAC', 'TT', 'TV', 'V1', 'V2', 'WH', 'XAA', 'YY', 'ZZZ'))">
	Value of 'ram:ReasonCode[not (@listID)]' is not allowed.</assert>
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge[ram:ChargeIndicator/udt:Indicator=&quot;true&quot;]/ram:SequenceNumeric">
      <report test="true()">
	Element 'ram:SequenceNumeric' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation">
      <assert id="FX-SCH-A-000382" test="count(ram:LineTotalAmount)&lt;=1">
	Element 'ram:LineTotalAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001140" test="count(ram:ChargeTotalAmount)&lt;=1">
	Element 'ram:ChargeTotalAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001141" test="count(ram:AllowanceTotalAmount)&lt;=1">
	Element 'ram:AllowanceTotalAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000387" test="count(ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000388" test="count(ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode])&lt;=1">
	Element variant 'ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode]' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000340" test="count(ram:GrandTotalAmount)&lt;=1">
	Element 'ram:GrandTotalAmount' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000341" test="count(ram:TotalAllowanceChargeAmount)&lt;=1">
	Element 'ram:TotalAllowanceChargeAmount' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:AllowanceTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:ChargeTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:GrandTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[ not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode) and  not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]">
      <report test="true()">
	Element variant 'ram:TaxTotalAmount[ not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode) and  not(@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode)]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode]">
      <let name="codeValue31" value="@currencyID"/>
      <assert id="FX-SCH-A-001142" test="string-length($codeValue31)=0 or ($codeValue31 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TaxTotalAmount[@currencyID=/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode]">
      <let name="codeValue32" value="@currencyID"/>
      <assert id="FX-SCH-A-001143" test="string-length($codeValue32)=0 or ($codeValue32 = ('AED', 'AFN', 'ALL', 'AMD', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV', 'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF', 'CLP', 'CNH', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW', 'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC', 'XBD', 'XCD', 'XCG', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER', 'ZAR', 'ZMW', 'ZWG'))">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:TotalAllowanceChargeAmount">
      <report test="@currencyID">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct">
      <assert id="FX-SCH-A-000550" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-000625" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic">
      <assert id="FX-SCH-A-001144" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000384" test="count(ram:Value)&lt;=1">
	Element 'ram:Value' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableProductCharacteristic/ram:TypeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BatchID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:BuyerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification">
      <assert id="FX-SCH-A-000342" test="count(ram:ClassName)&lt;=1">
	Element 'ram:ClassName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode">
      <assert id="FX-SCH-A-000296" test="@listID">
	Attribute '@listID' is required in this context.</assert>
      <let name="codeValue9" value="@listID"/>
      <assert id="FX-SCH-A-001145" test="string-length($codeValue9)=0 or ($codeValue9 = ('AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'AW', 'AX', 'AY', 'AZ', 'BA', 'BB', 'BC', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BK', 'BL', 'BM', 'BN', 'BO', 'BP', 'BQ', 'BR', 'BS', 'BT', 'BU', 'BV', 'BW', 'BX', 'BY', 'BZ', 'CC', 'CG', 'CL', 'CR', 'CV', 'DR', 'DW', 'EC', 'EF', 'EMD', 'EN', 'FS', 'GB', 'GMN', 'GN', 'GS', 'HS', 'IB', 'IN', 'IS', 'IT', 'IZ', 'MA', 'MF', 'MN', 'MP', 'NB', 'ON', 'PD', 'PL', 'PO', 'PPI', 'PV', 'QS', 'RC', 'RN', 'RU', 'RY', 'SA', 'SG', 'SK', 'SN', 'SRS', 'SRT', 'SRU', 'SRV', 'SRW', 'SRX', 'SRY', 'SRZ', 'SS', 'SSA', 'SSB', 'SSC', 'SSD', 'SSE', 'SSF', 'SSG', 'SSH', 'SSI', 'SSJ', 'SSK', 'SSL', 'SSM', 'SSN', 'SSO', 'SSP', 'SSQ', 'SSR', 'SSS', 'SST', 'SSU', 'SSV', 'SSW', 'SSX', 'SSY', 'SSZ', 'ST', 'STA', 'STB', 'STC', 'STD', 'STE', 'STF', 'STG', 'STH', 'STI', 'STJ', 'STK', 'STL', 'STM', 'STN', 'STO', 'STP', 'STQ', 'STR', 'STS', 'STT', 'STU', 'STV', 'STW', 'STX', 'STY', 'STZ', 'SUA', 'SUB', 'SUC', 'SUD', 'SUE', 'SUF', 'SUG', 'SUH', 'SUI', 'SUJ', 'SUK', 'SUL', 'SUM', 'TG', 'TSN', 'TSO', 'TSP', 'TSQ', 'TSR', 'TSS', 'TST', 'TSU', 'UA', 'UP', 'VN', 'VP', 'VS', 'VX', 'ZZZ'))">
	Value of '@listID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID">
      <assert id="FX-SCH-A-000551" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue8" value="@schemeID"/>
      <assert id="FX-SCH-A-001146" test="string-length($codeValue8)=0 or ($codeValue8 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct">
      <assert id="FX-SCH-A-001147" test="count(ram:ID)&lt;=1">
	Element 'ram:ID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000343" test="count(ram:IndustryAssignedID)&lt;=1">
	Element 'ram:IndustryAssignedID' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001148" test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001149" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000344" test="count(ram:UnitQuantity)&lt;=1">
	Element 'ram:UnitQuantity' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:BuyerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:GlobalID">
      <assert id="FX-SCH-A-001150" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue14" value="@schemeID"/>
      <assert id="FX-SCH-A-001151" test="string-length($codeValue14)=0 or ($codeValue14 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:IndustryAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:SellerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:UnitQuantity">
      <assert id="FX-SCH-A-001152" test="@unitCode">
	Attribute '@unitCode' is required in this context.</assert>
      <let name="codeValue15" value="@unitCode"/>
      <assert id="FX-SCH-A-001153" test="string-length($codeValue15)=0 or ($codeValue15 = ('10', '11', '13', '14', '15', '20', '21', '22', '23', '24', '25', '27', '28', '33', '34', '35', '37', '38', '40', '41', '56', '57', '58', '59', '60', '61', '74', '77', '80', '81', '85', '87', '89', '91', '1I', '2A', '2B', '2C', '2G', '2H', '2I', '2J', '2K', '2L', '2M', '2N', '2P', '2Q', '2R', '2U', '2X', '2Y', '2Z', '3B', '3C', '4C', '4G', '4H', '4K', '4L', '4M', '4N', '4O', '4P', '4Q', '4R', '4T', '4U', '4W', '4X', '5A', '5B', '5E', '5J', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A2', 'A20', 'A21', 'A22', 'A23', 'A24', 'A26', 'A27', 'A28', 'A29', 'A3', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A4', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A47', 'A48', 'A49', 'A5', 'A53', 'A54', 'A55', 'A56', 'A59', 'A6', 'A68', 'A69', 'A7', 'A70', 'A71', 'A73', 'A74', 'A75', 'A76', 'A8', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A9', 'A90', 'A91', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'AA', 'AB', 'ACR', 'ACT', 'AD', 'AE', 'AH', 'AI', 'AK', 'AL', 'AMH', 'AMP', 'ANN', 'APZ', 'AQ', 'AS', 'ASM', 'ASU', 'ATM', 'AWG', 'AY', 'AZ', 'B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B20', 'B21', 'B22', 'B23', 'B24', 'B25', 'B26', 'B27', 'B28', 'B29', 'B3', 'B30', 'B31', 'B32', 'B33', 'B34', 'B35', 'B4', 'B41', 'B42', 'B43', 'B44', 'B45', 'B46', 'B47', 'B48', 'B49', 'B50', 'B52', 'B53', 'B54', 'B55', 'B56', 'B57', 'B58', 'B59', 'B60', 'B61', 'B62', 'B63', 'B64', 'B66', 'B67', 'B68', 'B69', 'B7', 'B70', 'B71', 'B72', 'B73', 'B74', 'B75', 'B76', 'B77', 'B78', 'B79', 'B8', 'B80', 'B81', 'B82', 'B83', 'B84', 'B85', 'B86', 'B87', 'B88', 'B89', 'B90', 'B91', 'B92', 'B93', 'B94', 'B95', 'B96', 'B97', 'B98', 'B99', 'BAR', 'BB', 'BFT', 'BHP', 'BIL', 'BLD', 'BLL', 'BP', 'BPM', 'BQL', 'BTU', 'BUA', 'BUI', 'C0', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25', 'C26', 'C27', 'C28', 'C29', 'C3', 'C30', 'C31', 'C32', 'C33', 'C34', 'C35', 'C36', 'C37', 'C38', 'C39', 'C40', 'C41', 'C42', 'C43', 'C44', 'C45', 'C46', 'C47', 'C48', 'C49', 'C50', 'C51', 'C52', 'C53', 'C54', 'C55', 'C56', 'C57', 'C58', 'C59', 'C60', 'C61', 'C62', 'C63', 'C64', 'C65', 'C66', 'C67', 'C68', 'C69', 'C7', 'C70', 'C71', 'C72', 'C73', 'C74', 'C75', 'C76', 'C78', 'C79', 'C8', 'C80', 'C81', 'C82', 'C83', 'C84', 'C85', 'C86', 'C87', 'C88', 'C89', 'C9', 'C90', 'C91', 'C92', 'C93', 'C94', 'C95', 'C96', 'C97', 'C99', 'CCT', 'CDL', 'CEL', 'CEN', 'CG', 'CGM', 'CKG', 'CLF', 'CLT', 'CMK', 'CMQ', 'CMT', 'CNP', 'CNT', 'COU', 'CTG', 'CTM', 'CTN', 'CUR', 'CWA', 'CWI', 'D03', 'D04', 'D1', 'D10', 'D11', 'D12', 'D13', 'D15', 'D16', 'D17', 'D18', 'D19', 'D2', 'D20', 'D21', 'D22', 'D23', 'D24', 'D25', 'D26', 'D27', 'D29', 'D30', 'D31', 'D32', 'D33', 'D34', 'D36', 'D41', 'D42', 'D43', 'D44', 'D45', 'D46', 'D47', 'D48', 'D49', 'D5', 'D50', 'D51', 'D52', 'D53', 'D54', 'D55', 'D56', 'D57', 'D58', 'D59', 'D6', 'D60', 'D61', 'D62', 'D63', 'D65', 'D68', 'D69', 'D73', 'D74', 'D77', 'D78', 'D80', 'D81', 'D82', 'D83', 'D85', 'D86', 'D87', 'D88', 'D89', 'D91', 'D93', 'D94', 'D95', 'DAA', 'DAD', 'DAY', 'DB', 'DBM', 'DBW', 'DD', 'DEC', 'DG', 'DJ', 'DLT', 'DMA', 'DMK', 'DMO', 'DMQ', 'DMT', 'DN', 'DPC', 'DPR', 'DPT', 'DRA', 'DRI', 'DRL', 'DT', 'DTN', 'DWT', 'DZN', 'DZP', 'E01', 'E07', 'E08', 'E09', 'E10', 'E12', 'E14', 'E15', 'E16', 'E17', 'E18', 'E19', 'E20', 'E21', 'E22', 'E23', 'E25', 'E27', 'E28', 'E30', 'E31', 'E32', 'E33', 'E34', 'E35', 'E36', 'E37', 'E38', 'E39', 'E4', 'E40', 'E41', 'E42', 'E43', 'E44', 'E45', 'E46', 'E47', 'E48', 'E49', 'E50', 'E51', 'E52', 'E53', 'E54', 'E55', 'E56', 'E57', 'E58', 'E59', 'E60', 'E61', 'E62', 'E63', 'E64', 'E65', 'E66', 'E67', 'E68', 'E69', 'E70', 'E71', 'E72', 'E73', 'E74', 'E75', 'E76', 'E77', 'E78', 'E79', 'E80', 'E81', 'E82', 'E83', 'E84', 'E85', 'E86', 'E87', 'E88', 'E89', 'E90', 'E91', 'E92', 'E93', 'E94', 'E95', 'E96', 'E97', 'E98', 'E99', 'EA', 'EB', 'EQ', 'F01', 'F02', 'F03', 'F04', 'F05', 'F06', 'F07', 'F08', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21', 'F22', 'F23', 'F24', 'F25', 'F26', 'F27', 'F28', 'F29', 'F30', 'F31', 'F32', 'F33', 'F34', 'F35', 'F36', 'F37', 'F38', 'F39', 'F40', 'F41', 'F42', 'F43', 'F44', 'F45', 'F46', 'F47', 'F48', 'F49', 'F50', 'F51', 'F52', 'F53', 'F54', 'F55', 'F56', 'F57', 'F58', 'F59', 'F60', 'F61', 'F62', 'F63', 'F64', 'F65', 'F66', 'F67', 'F68', 'F69', 'F70', 'F71', 'F72', 'F73', 'F74', 'F75', 'F76', 'F77', 'F78', 'F79', 'F80', 'F81', 'F82', 'F83', 'F84', 'F85', 'F86', 'F87', 'F88', 'F89', 'F90', 'F91', 'F92', 'F93', 'F94', 'F95', 'F96', 'F97', 'F98', 'F99', 'FAH', 'FAR', 'FBM', 'FC', 'FF', 'FH', 'FIT', 'FL', 'FNU', 'FOT', 'FP', 'FR', 'FS', 'FTK', 'FTQ', 'G01', 'G04', 'G05', 'G06', 'G08', 'G09', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G17', 'G18', 'G19', 'G2', 'G20', 'G21', 'G23', 'G24', 'G25', 'G26', 'G27', 'G28', 'G29', 'G3', 'G30', 'G31', 'G32', 'G33', 'G34', 'G35', 'G36', 'G37', 'G38', 'G39', 'G40', 'G41', 'G42', 'G43', 'G44', 'G45', 'G46', 'G47', 'G48', 'G49', 'G50', 'G51', 'G52', 'G53', 'G54', 'G55', 'G56', 'G57', 'G58', 'G59', 'G60', 'G61', 'G62', 'G63', 'G64', 'G65', 'G66', 'G67', 'G68', 'G69', 'G70', 'G71', 'G72', 'G73', 'G74', 'G75', 'G76', 'G77', 'G78', 'G79', 'G80', 'G81', 'G82', 'G83', 'G84', 'G85', 'G86', 'G87', 'G88', 'G89', 'G90', 'G91', 'G92', 'G93', 'G94', 'G95', 'G96', 'G97', 'G98', 'G99', 'GB', 'GBQ', 'GDW', 'GE', 'GF', 'GFI', 'GGR', 'GIA', 'GIC', 'GII', 'GIP', 'GJ', 'GL', 'GLD', 'GLI', 'GLL', 'GM', 'GO', 'GP', 'GQ', 'GRM', 'GRN', 'GRO', 'GV', 'GWH', 'H03', 'H04', 'H05', 'H06', 'H07', 'H08', 'H09', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H18', 'H19', 'H20', 'H21', 'H22', 'H23', 'H24', 'H25', 'H26', 'H27', 'H28', 'H29', 'H30', 'H31', 'H32', 'H33', 'H34', 'H35', 'H36', 'H37', 'H38', 'H39', 'H40', 'H41', 'H42', 'H43', 'H44', 'H45', 'H46', 'H47', 'H48', 'H49', 'H50', 'H51', 'H52', 'H53', 'H54', 'H55', 'H56', 'H57', 'H58', 'H59', 'H60', 'H61', 'H62', 'H63', 'H64', 'H65', 'H66', 'H67', 'H68', 'H69', 'H70', 'H71', 'H72', 'H73', 'H74', 'H75', 'H76', 'H77', 'H79', 'H80', 'H81', 'H82', 'H83', 'H84', 'H85', 'H87', 'H88', 'H89', 'H90', 'H91', 'H92', 'H93', 'H94', 'H95', 'H96', 'H98', 'H99', 'HA', 'HAD', 'HBA', 'HBX', 'HC', 'HDW', 'HEA', 'HGM', 'HH', 'HIU', 'HKM', 'HLT', 'HM', 'HMO', 'HMQ', 'HMT', 'HPA', 'HTZ', 'HUR', 'HWE', 'IA', 'IE', 'INH', 'INK', 'INQ', 'ISD', 'IU', 'IUG', 'IV', 'J10', 'J12', 'J13', 'J14', 'J15', 'J16', 'J17', 'J18', 'J19', 'J2', 'J20', 'J21', 'J22', 'J23', 'J24', 'J25', 'J26', 'J27', 'J28', 'J29', 'J30', 'J31', 'J32', 'J33', 'J34', 'J35', 'J36', 'J38', 'J39', 'J40', 'J41', 'J42', 'J43', 'J44', 'J45', 'J46', 'J47', 'J48', 'J49', 'J50', 'J51', 'J52', 'J53', 'J54', 'J55', 'J56', 'J57', 'J58', 'J59', 'J60', 'J61', 'J62', 'J63', 'J64', 'J65', 'J66', 'J67', 'J68', 'J69', 'J70', 'J71', 'J72', 'J73', 'J74', 'J75', 'J76', 'J78', 'J79', 'J81', 'J82', 'J83', 'J84', 'J85', 'J87', 'J90', 'J91', 'J92', 'J93', 'J95', 'J96', 'J97', 'J98', 'J99', 'JE', 'JK', 'JM', 'JNT', 'JOU', 'JPS', 'JWL', 'K1', 'K10', 'K11', 'K12', 'K13', 'K14', 'K15', 'K16', 'K17', 'K18', 'K19', 'K2', 'K20', 'K21', 'K22', 'K23', 'K26', 'K27', 'K28', 'K3', 'K30', 'K31', 'K32', 'K33', 'K34', 'K35', 'K36', 'K37', 'K38', 'K39', 'K40', 'K41', 'K42', 'K43', 'K45', 'K46', 'K47', 'K48', 'K49', 'K50', 'K51', 'K52', 'K53', 'K54', 'K55', 'K58', 'K59', 'K6', 'K60', 'K61', 'K62', 'K63', 'K64', 'K65', 'K66', 'K67', 'K68', 'K69', 'K70', 'K71', 'K73', 'K74', 'K75', 'K76', 'K77', 'K78', 'K79', 'K80', 'K81', 'K82', 'K83', 'K84', 'K85', 'K86', 'K87', 'K88', 'K89', 'K90', 'K91', 'K92', 'K93', 'K94', 'K95', 'K96', 'K97', 'K98', 'K99', 'KA', 'KAT', 'KB', 'KBA', 'KCC', 'KDW', 'KEL', 'KGM', 'KGS', 'KHY', 'KHZ', 'KI', 'KIC', 'KIP', 'KJ', 'KJO', 'KL', 'KLK', 'KLX', 'KMA', 'KMH', 'KMK', 'KMQ', 'KMT', 'KNI', 'KNM', 'KNS', 'KNT', 'KO', 'KPA', 'KPH', 'KPO', 'KPP', 'KR', 'KSD', 'KSH', 'KT', 'KTN', 'KUR', 'KVA', 'KVR', 'KVT', 'KW', 'KWH', 'KWN', 'KWO', 'KWS', 'KWT', 'KWY', 'KX', 'L10', 'L11', 'L12', 'L13', 'L14', 'L15', 'L16', 'L17', 'L18', 'L19', 'L2', 'L20', 'L21', 'L23', 'L24', 'L25', 'L26', 'L27', 'L28', 'L29', 'L30', 'L31', 'L32', 'L33', 'L34', 'L35', 'L36', 'L37', 'L38', 'L39', 'L40', 'L41', 'L42', 'L43', 'L44', 'L45', 'L46', 'L47', 'L48', 'L49', 'L50', 'L51', 'L52', 'L53', 'L54', 'L55', 'L56', 'L57', 'L58', 'L59', 'L60', 'L63', 'L64', 'L65', 'L66', 'L67', 'L68', 'L69', 'L70', 'L71', 'L72', 'L73', 'L74', 'L75', 'L76', 'L77', 'L78', 'L79', 'L80', 'L81', 'L82', 'L83', 'L84', 'L85', 'L86', 'L87', 'L88', 'L89', 'L90', 'L91', 'L92', 'L93', 'L94', 'L95', 'L96', 'L98', 'L99', 'LA', 'LAC', 'LBR', 'LBT', 'LD', 'LEF', 'LF', 'LH', 'LK', 'LM', 'LN', 'LO', 'LP', 'LPA', 'LR', 'LS', 'LTN', 'LTR', 'LUB', 'LUM', 'LUX', 'LY', 'M1', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20', 'M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M29', 'M30', 'M31', 'M32', 'M33', 'M34', 'M35', 'M36', 'M37', 'M38', 'M39', 'M4', 'M40', 'M41', 'M42', 'M43', 'M44', 'M45', 'M46', 'M47', 'M48', 'M49', 'M5', 'M50', 'M51', 'M52', 'M53', 'M55', 'M56', 'M57', 'M58', 'M59', 'M60', 'M61', 'M62', 'M63', 'M64', 'M65', 'M66', 'M67', 'M68', 'M69', 'M7', 'M70', 'M71', 'M72', 'M73', 'M74', 'M75', 'M76', 'M77', 'M78', 'M79', 'M80', 'M81', 'M82', 'M83', 'M84', 'M85', 'M86', 'M87', 'M88', 'M89', 'M9', 'M90', 'M91', 'M92', 'M93', 'M94', 'M95', 'M96', 'M97', 'M98', 'M99', 'MAH', 'MAL', 'MAM', 'MAR', 'MAW', 'MBE', 'MBF', 'MBR', 'MC', 'MCU', 'MD', 'MGM', 'MHZ', 'MIK', 'MIL', 'MIN', 'MIO', 'MIU', 'MKD', 'MKM', 'MKW', 'MLD', 'MLT', 'MMK', 'MMQ', 'MMT', 'MND', 'MNJ', 'MON', 'MPA', 'MQD', 'MQH', 'MQM', 'MQS', 'MQW', 'MRD', 'MRM', 'MRW', 'MSK', 'MTK', 'MTQ', 'MTR', 'MTS', 'MTZ', 'MVA', 'MWH', 'N1', 'N10', 'N11', 'N12', 'N13', 'N14', 'N15', 'N16', 'N17', 'N18', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25', 'N26', 'N27', 'N28', 'N29', 'N3', 'N30', 'N31', 'N32', 'N33', 'N34', 'N35', 'N36', 'N37', 'N38', 'N39', 'N40', 'N41', 'N42', 'N43', 'N44', 'N45', 'N46', 'N47', 'N48', 'N49', 'N50', 'N51', 'N52', 'N53', 'N54', 'N55', 'N56', 'N57', 'N58', 'N59', 'N60', 'N61', 'N62', 'N63', 'N64', 'N65', 'N66', 'N67', 'N68', 'N69', 'N70', 'N71', 'N72', 'N73', 'N74', 'N75', 'N76', 'N77', 'N78', 'N79', 'N80', 'N81', 'N82', 'N83', 'N84', 'N85', 'N86', 'N87', 'N88', 'N89', 'N90', 'N91', 'N92', 'N93', 'N94', 'N95', 'N96', 'N97', 'N98', 'N99', 'NA', 'NAR', 'NCL', 'NEW', 'NF', 'NIL', 'NIU', 'NL', 'NM3', 'NMI', 'NMP', 'NPT', 'NT', 'NTU', 'NU', 'NX', 'OA', 'ODE', 'ODG', 'ODK', 'ODM', 'OHM', 'ON', 'ONZ', 'OPM', 'OT', 'OZA', 'OZI', 'P1', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P2', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25', 'P26', 'P27', 'P28', 'P29', 'P30', 'P31', 'P32', 'P33', 'P34', 'P35', 'P36', 'P37', 'P38', 'P39', 'P40', 'P41', 'P42', 'P43', 'P44', 'P45', 'P46', 'P47', 'P48', 'P49', 'P5', 'P50', 'P51', 'P52', 'P53', 'P54', 'P55', 'P56', 'P57', 'P58', 'P59', 'P60', 'P61', 'P62', 'P63', 'P64', 'P65', 'P66', 'P67', 'P68', 'P69', 'P70', 'P71', 'P72', 'P73', 'P74', 'P75', 'P76', 'P77', 'P78', 'P79', 'P80', 'P81', 'P82', 'P83', 'P84', 'P85', 'P86', 'P87', 'P88', 'P89', 'P90', 'P91', 'P92', 'P93', 'P94', 'P95', 'P96', 'P97', 'P98', 'P99', 'PAL', 'PD', 'PFL', 'PGL', 'PI', 'PLA', 'PO', 'PQ', 'PR', 'PS', 'PTD', 'PTI', 'PTL', 'PTN', 'Q10', 'Q11', 'Q12', 'Q13', 'Q14', 'Q15', 'Q16', 'Q17', 'Q18', 'Q19', 'Q20', 'Q21', 'Q22', 'Q23', 'Q24', 'Q25', 'Q26', 'Q27', 'Q28', 'Q29', 'Q3', 'Q30', 'Q31', 'Q32', 'Q33', 'Q34', 'Q35', 'Q36', 'Q37', 'Q38', 'Q39', 'Q40', 'Q41', 'Q42', 'QA', 'QAN', 'QB', 'QR', 'QTD', 'QTI', 'QTL', 'QTR', 'R1', 'R9', 'RH', 'RM', 'ROM', 'RP', 'RPM', 'RPS', 'RT', 'S3', 'S4', 'SAN', 'SCO', 'SCR', 'SEC', 'SET', 'SG', 'SIE', 'SM3', 'SMI', 'SQ', 'SQR', 'SR', 'STC', 'STI', 'STK', 'STL', 'STN', 'STW', 'SW', 'SX', 'SYR', 'T0', 'T3', 'TAH', 'TAN', 'TI', 'TIC', 'TIP', 'TKM', 'TMS', 'TNE', 'TP', 'TPI', 'TPR', 'TQD', 'TRL', 'TST', 'TTS', 'U1', 'U2', 'UB', 'UC', 'VA', 'VLT', 'VP', 'W2', 'WA', 'WB', 'WCD', 'WE', 'WEB', 'WEE', 'WG', 'WHR', 'WM', 'WSD', 'WTT', 'X1', 'X1A', 'X1B', 'X1D', 'X1F', 'X1G', 'X1W', 'X2C', 'X3A', 'X3H', 'X43', 'X44', 'X4A', 'X4B', 'X4C', 'X4D', 'X4F', 'X4G', 'X4H', 'X5H', 'X5L', 'X5M', 'X6H', 'X6P', 'X7A', 'X7B', 'X8A', 'X8B', 'X8C', 'XAA', 'XAB', 'XAC', 'XAD', 'XAE', 'XAF', 'XAG', 'XAH', 'XAI', 'XAJ', 'XAL', 'XAM', 'XAP', 'XAT', 'XAV', 'XB4', 'XBA', 'XBB', 'XBC', 'XBD', 'XBE', 'XBF', 'XBG', 'XBH', 'XBI', 'XBJ', 'XBK', 'XBL', 'XBM', 'XBN', 'XBO', 'XBP', 'XBQ', 'XBR', 'XBS', 'XBT', 'XBU', 'XBV', 'XBW', 'XBX', 'XBY', 'XBZ', 'XCA', 'XCB', 'XCC', 'XCD', 'XCE', 'XCF', 'XCG', 'XCH', 'XCI', 'XCJ', 'XCK', 'XCL', 'XCM', 'XCN', 'XCO', 'XCP', 'XCQ', 'XCR', 'XCS', 'XCT', 'XCU', 'XCV', 'XCW', 'XCX', 'XCY', 'XCZ', 'XDA', 'XDB', 'XDC', 'XDG', 'XDH', 'XDI', 'XDJ', 'XDK', 'XDL', 'XDM', 'XDN', 'XDP', 'XDR', 'XDS', 'XDT', 'XDU', 'XDV', 'XDW', 'XDX', 'XDY', 'XEC', 'XED', 'XEE', 'XEF', 'XEG', 'XEH', 'XEI', 'XEN', 'XFB', 'XFC', 'XFD', 'XFE', 'XFI', 'XFL', 'XFO', 'XFP', 'XFR', 'XFT', 'XFW', 'XFX', 'XGB', 'XGI', 'XGL', 'XGR', 'XGU', 'XGY', 'XGZ', 'XHA', 'XHB', 'XHC', 'XHG', 'XHN', 'XHR', 'XIA', 'XIB', 'XIC', 'XID', 'XIE', 'XIF', 'XIG', 'XIH', 'XIK', 'XIL', 'XIN', 'XIZ', 'XJB', 'XJC', 'XJG', 'XJR', 'XJT', 'XJY', 'XKG', 'XKI', 'XLE', 'XLG', 'XLT', 'XLU', 'XLV', 'XLZ', 'XMA', 'XMB', 'XMC', 'XME', 'XMR', 'XMS', 'XMT', 'XMW', 'XMX', 'XNA', 'XNE', 'XNF', 'XNG', 'XNS', 'XNT', 'XNU', 'XNV', 'XO1', 'XO2', 'XO3', 'XO4', 'XO5', 'XO6', 'XO7', 'XO8', 'XO9', 'XOA', 'XOB', 'XOC', 'XOD', 'XOE', 'XOF', 'XOG', 'XOH', 'XOI', 'XOJ', 'XOK', 'XOL', 'XOM', 'XON', 'XOP', 'XOQ', 'XOR', 'XOS', 'XOT', 'XOU', 'XOV', 'XOW', 'XOX', 'XOY', 'XOZ', 'XP1', 'XP2', 'XP3', 'XP4', 'XPA', 'XPB', 'XPC', 'XPD', 'XPE', 'XPF', 'XPG', 'XPH', 'XPI', 'XPJ', 'XPK', 'XPL', 'XPN', 'XPO', 'XPP', 'XPR', 'XPT', 'XPU', 'XPV', 'XPX', 'XPY', 'XPZ', 'XQA', 'XQB', 'XQC', 'XQD', 'XQF', 'XQG', 'XQH', 'XQJ', 'XQK', 'XQL', 'XQM', 'XQN', 'XQP', 'XQQ', 'XQR', 'XQS', 'XRD', 'XRG', 'XRJ', 'XRK', 'XRL', 'XRO', 'XRT', 'XRZ', 'XSA', 'XSB', 'XSC', 'XSD', 'XSE', 'XSH', 'XSI', 'XSK', 'XSL', 'XSM', 'XSO', 'XSP', 'XSS', 'XST', 'XSU', 'XSV', 'XSW', 'XSX', 'XSY', 'XSZ', 'XT1', 'XTB', 'XTC', 'XTD', 'XTE', 'XTG', 'XTI', 'XTK', 'XTL', 'XTN', 'XTO', 'XTR', 'XTS', 'XTT', 'XTU', 'XTV', 'XTW', 'XTY', 'XTZ', 'XUC', 'XUN', 'XVA', 'XVG', 'XVI', 'XVK', 'XVL', 'XVN', 'XVO', 'XVP', 'XVQ', 'XVR', 'XVS', 'XVY', 'XWA', 'XWB', 'XWC', 'XWD', 'XWF', 'XWG', 'XWH', 'XWJ', 'XWK', 'XWL', 'XWM', 'XWN', 'XWP', 'XWQ', 'XWR', 'XWS', 'XWT', 'XWU', 'XWV', 'XWW', 'XWX', 'XWY', 'XWZ', 'XXA', 'XXB', 'XXC', 'XXD', 'XXF', 'XXG', 'XXH', 'XXJ', 'XXK', 'XYA', 'XYB', 'XYC', 'XYD', 'XYF', 'XYG', 'XYH', 'XYJ', 'XYK', 'XYL', 'XYM', 'XYN', 'XYP', 'XYQ', 'XYR', 'XYS', 'XYT', 'XYV', 'XYW', 'XYX', 'XYY', 'XYZ', 'XZA', 'XZB', 'XZC', 'XZD', 'XZF', 'XZG', 'XZH', 'XZJ', 'XZK', 'XZL', 'XZM', 'XZN', 'XZP', 'XZQ', 'XZR', 'XZS', 'XZT', 'XZU', 'XZV', 'XZW', 'XZX', 'XZY', 'XZZ', 'YDK', 'YDQ', 'YRD', 'Z11', 'Z9', 'ZP', 'ZZ'))">
	Value of '@unitCode' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IndividualTradeProductInstance/ram:BatchID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IndividualTradeProductInstance/ram:SupplierAssignedSerialID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IndustryAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty">
      <assert id="FX-SCH-A-001154" test="count(ram:RoleCode)&lt;=1">
	Element 'ram:RoleCode' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001155" test="count(ram:Description)&lt;=1">
	Element 'ram:Description' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-001156" test="count(ram:URIUniversalCommunication)&lt;=1">
	Element 'ram:URIUniversalCommunication' may occur at maximum 1 times.</assert>
      <assert id="FX-SCH-A-000386" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;])&lt;=2">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="VA"]' may occur at maximum 2 times.</assert>
      <assert id="FX-SCH-A-000385" test="count(ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;])&lt;=2">
	Element variant 'ram:SpecifiedTaxRegistration[ram:ID/@schemeID="FC"]' may occur at maximum 2 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication">
      <assert id="FX-SCH-A-001157" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication">
      <assert id="FX-SCH-A-001158" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication">
      <assert id="FX-SCH-A-001159" test="count(ram:CompleteNumber)=1">
	Element 'ram:CompleteNumber' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:GlobalID">
      <assert id="FX-SCH-A-001160" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue11" value="@schemeID"/>
      <assert id="FX-SCH-A-001161" test="string-length($codeValue11)=0 or ($codeValue11 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248', 'BY', 'SE'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:ID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:PostalTradeAddress">
      <assert id="FX-SCH-A-001162" test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
      <assert id="FX-SCH-A-001163" test="count(ram:CountrySubDivisionName)&lt;=1">
	Element 'ram:CountrySubDivisionName' may occur at maximum 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:PostalTradeAddress/ram:CountryID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001164" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:CountryID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="@listID">
	Attribute @listID' marked as not used in the given context.</report>
      <report test="@listVersionID">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
      <let name="codeValue12" value="@schemeID"/>
      <assert id="FX-SCH-A-001165" test="string-length($codeValue12)=0 or ($codeValue12 = ('0002', '0003', '0004', '0005', '0006', '0007', '0008', '0009', '0010', '0011', '0012', '0013', '0014', '0015', '0016', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0029', '0030', '0031', '0032', '0033', '0034', '0035', '0036', '0037', '0038', '0039', '0040', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048', '0049', '0050', '0051', '0052', '0053', '0054', '0055', '0056', '0057', '0058', '0059', '0060', '0061', '0062', '0063', '0064', '0065', '0066', '0067', '0068', '0069', '0070', '0071', '0072', '0073', '0074', '0075', '0076', '0077', '0078', '0079', '0080', '0081', '0082', '0083', '0084', '0085', '0086', '0087', '0088', '0089', '0090', '0091', '0093', '0094', '0095', '0096', '0097', '0098', '0099', '0100', '0101', '0102', '0104', '0105', '0106', '0107', '0108', '0109', '0110', '0111', '0112', '0113', '0114', '0115', '0116', '0117', '0118', '0119', '0120', '0121', '0122', '0123', '0124', '0125', '0126', '0127', '0128', '0129', '0130', '0131', '0132', '0133', '0134', '0135', '0136', '0137', '0138', '0139', '0140', '0141', '0142', '0143', '0144', '0145', '0146', '0147', '0148', '0149', '0150', '0151', '0152', '0153', '0154', '0155', '0156', '0157', '0158', '0159', '0160', '0161', '0162', '0163', '0164', '0165', '0166', '0167', '0168', '0169', '0170', '0171', '0172', '0173', '0174', '0175', '0176', '0177', '0178', '0179', '0180', '0183', '0184', '0185', '0186', '0187', '0188', '0189', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0197', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0206', '0207', '0208', '0209', '0210', '0211', '0212', '0213', '0214', '0215', '0216', '0217', '0218', '0219', '0220', '0221', '0222', '0223', '0224', '0225', '0226', '0227', '0228', '0229', '0230', '0231', '0232', '0233', '0234', '0235', '0236', '0237', '0238', '0239', '0240', '0241', '0242', '0243', '0244', '0245', '0246', '0247', '0248'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID=&quot;VA&quot;) and  not(ram:ID/@schemeID=&quot;FC&quot;)]">
      <report test="true()">
	Element variant 'ram:SpecifiedTaxRegistration[ not(ram:ID/@schemeID="VA") and  not(ram:ID/@schemeID="FC")]' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]">
      <assert id="FX-SCH-A-001166" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;FC&quot;]/ram:ID">
      <assert id="FX-SCH-A-001167" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]">
      <assert id="FX-SCH-A-001168" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:SpecifiedTaxRegistration[ram:ID/@schemeID=&quot;VA&quot;]/ram:ID">
      <assert id="FX-SCH-A-001169" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:URIUniversalCommunication">
      <assert id="FX-SCH-A-001170" test="count(ram:URIID)=1">
	Element 'ram:URIID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:URIUniversalCommunication/ram:CompleteNumber">
      <report test="true()">
	Element 'ram:CompleteNumber' is marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ManufacturerTradeParty/ram:URIUniversalCommunication/ram:URIID">
      <assert id="FX-SCH-A-001171" test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
      <let name="codeValue13" value="@schemeID"/>
      <assert id="FX-SCH-A-001172" test="string-length($codeValue13)=0 or ($codeValue13 = ('0002', '0007', '0009', '0037', '0060', '0088', '0096', '0097', '0106', '0130', '0135', '0142', '0147', '0151', '0154', '0158', '0170', '0177', '0183', '0184', '0188', '0190', '0191', '0192', '0193', '0194', '0195', '0196', '0198', '0199', '0200', '0201', '0202', '0203', '0204', '0205', '0208', '0209', '0210', '0211', '0212', '0213', '0215', '0216', '0217', '0218', '0221', '0225', '0230', '0235', '0240', '0242', '0244', '0245', '0246', '0248', '9910', '9913', '9914', '9915', '9918', '9919', '9920', '9922', '9923', '9924', '9925', '9926', '9927', '9928', '9929', '9930', '9931', '9932', '9933', '9934', '9935', '9936', '9937', '9938', '9939', '9940', '9941', '9942', '9943', '9944', '9945', '9946', '9947', '9948', '9949', '9950', '9951', '9952', '9953', '9957', '9959', 'AN', 'AQ', 'AS', 'AU', 'EM'))">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ModelID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry">
      <assert id="FX-SCH-A-000627" test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:OriginTradeCountry/ram:ID">
      <let name="codeValue10" value="."/>
      <assert id="FX-SCH-A-001173" test="string-length($codeValue10)=0 or ($codeValue10 = ('1A', 'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'XI', 'YE', 'YT', 'ZA', 'ZM', 'ZW', '1A', 'XI'))">
	Value of 'ram:ID' is not allowed.</assert>
    </rule>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:SellerAssignedID">
      <report test="@schemeID">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
</schema>
