<#-- 
Liferay 7.2
ADT example
Freemarker
ADT.ftl 
-->

<#assign 
    dlFileEntryUtil = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")
    dlAppService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLAppService")
    dlUtil = serviceLocator.findService("com.liferay.document.library.kernel.util.DLUtil")
	prefix = "senci"
/>

<#if entries?has_content>

	<#--  Truncate Text  -->
	<#macro truncate_text text limit>
		<#assign truncatedText = "" />

		<#if text?length gt limit>
			<#assign truncatedText = text?substring(0,limit)/>
			<#assign truncatedText += "..."/>
			${truncatedText}
		<#else>
			${text}
		</#if>
	</#macro>

	<#--  Asset Entries  -->
	<#macro asset_entries_include assetEntryContext>
		<#assign
			renderer = assetEntryContext.getAssetRenderer()
			journalArticle = renderer.getArticle()
			document = saxReaderUtil.read(journalArticle.getContent())
			rootElement = document.getRootElement()

			xPathSelector = saxReaderUtil.createXPath("dynamic-element[@name='news_image']")
			newsImage = xPathSelector.selectSingleNode(rootElement).getStringValue()?trim

			xPathSelector = saxReaderUtil.createXPath("dynamic-element[@name='news_content']")
			newsContent = xPathSelector.selectSingleNode(rootElement).getStringValue()?trim
			
			<#--  Get groupId and uuid -->
			jsonObject =  jsonFactoryUtil.createJSONObject(newsImage)
			fileGroupId =  getterUtil.getInteger(jsonObject.get('groupId'))
			fileUuid =  getterUtil.getString(jsonObject.get('uuid'))
			
			<#--  Get fileEntryId from the document  -->
			fileEntry = dlFileEntryUtil.getDLFileEntryByUuidAndGroupId(fileUuid, fileGroupId)
			fileEntryId = fileEntry.getFileEntryId()
		/>

		<#--  Create urlDocument  -->
		<#if fileEntryId?? && fileEntryId != 0>
			<#assign
				fileEntry = dlAppService.getFileEntry(fileEntryId)
				fielURL = dlUtil.getDownloadURL(fileEntry, fileEntry.getFileVersion(), themeDisplay, null)
			/>
		<#else>
			<#assign fielURL = "#">
		</#if>
			
		<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, assetEntryContext) />
				
		<#if assetLinkBehavior != "showFullContent">
			<#assign viewURL = renderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
		</#if>
	</#macro>



            <#assign count = 0 />

            <#list entries as curEntry>
            
                <@asset_entries_include assetEntryContext=curEntry />
                
                <#if count == 0 >

                        ${fielURL}
                        
                        ${viewURL}
                        
                        ${curEntry.getTitle(locale)}
                                    
                        <#assign publishDate = journalArticle.getModifiedDate()>
                        ${publishDate?datetime?string("dd MMMM yyyy")}		
                
                </#if>

                <#assign count = count + 1 />
            
            </#list>

            
</#if>