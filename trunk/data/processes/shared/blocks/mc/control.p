^rem{ �������� ��������� ������ ������� }
^executeSystemProcess[$.id[1]]
# ������������ ������
<block_content>
	$lparams.body
#	���� ������ �� ����� "picker" ������� ����� ������ �������
	^if($form:mode ne 'picker'){
	<buttons>
			<button image="24_sites.gif"      name="sites"     alt="���������� �������"        onClick="Go('$OBJECTS_HASH.80.full_path?type=sites','#container')" />
			<button image="24_objects.gif"    name="objects"   alt="���������� ���������"      onClick="Go('$OBJECTS_HASH.80.full_path?type=objects','#container')" />
			<button image="24_blocks.gif"     name="blocks"    alt="���������� �������"        onClick="Go('$OBJECTS_HASH.80.full_path?type=blocks','#container')" />
			<button image="24_process.gif"    name="process"   alt="���������� �������������"  onClick="Go('$OBJECTS_HASH.80.full_path?type=process','#container')" />
			<button image="24_templates.gif"  name="templates" alt="���������� ���������"      onClick="Go('$OBJECTS_HASH.80.full_path?type=templates','#container')" />
			<button image="24_users.gif"      name="users"     alt="���������� �������������� � ��������" onClick="Go('$OBJECTS_HASH.80.full_path?type=users','#container')" />
			<button image="24_rights.gif"     name="rigths"    alt="���������� ����"           onClick="Go('$OBJECTS_HASH.80.full_path?type=rights','#container')" />
			<button image="24_configure.gif"  name="configure" alt="������������ �������"      onClick="Go('$OBJECTS_HASH.80.full_path?type=config','#container')" />
			<button image="24_files.gif"      name="files"     alt="�������� ������"           onClick="Go('$OBJECTS_HASH.80.full_path?type=files','#container')" />
			<button image="24_divider.gif" />
		^if(def $form:action && $form:action ne 'config'){
			<button image="24_save.gif"    name="save"      alt="���������" onClick="saveForm('form_content','${OBJECTS_HASH.80.full_path}?type=$form:type','#container')" />
			<button image="24_retype.gif"  name="retype"    alt="��������"  onClick="resetForm()" />
			<button image="24_cancel.gif"  name="cancel"    alt="��������"  onClick="Cancel('$OBJECTS_HASH.80.full_path?type=$form:type')" />
		}
	</buttons>
	}
	$_jMethod[$[$form:type]]
	^_jMethod[]
</block_content>
#################################################################################################
#                                                                                               #
#                                    ����� �����                                                #
#                                                                                               #
#################################################################################################

# -----------------------------------------------------------------------------------------------
#                                    ���������� �������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� �������
@sites[]
^if(def $form:action){
	^if($form:action eq 'edit'){$_iR($_iR + 1) $_sLabel[������������� ]}
	^if($form:action eq 'copy'){$_iR($_iR + 2) $_sLabel[����������� ]}
	^if($form:action eq 'add'){ $_iR($_iR + 4) $_sLabel[���������� ]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data" 
	label="MOUSE CMS | ����� | $_sLabel | $SITES_HASH.[$form:id].name ">
	<tabs>
	<tab id="section-1" name="��������">
		<field type="text"   name="name"           label="��������"   description="��� �����"              class="long">$SITES_HASH.[$form:id].name</field>
		<field type="text"   name="domain"         label="�����"      description="�������� ���"           class="medium">$SITES_HASH.[$form:id].domain</field>
		<field type="select" name="lang_id"        label="����"       description="���� �����"             class="short"><option value="1">�������</option></field>
	^if($_iR & 1){
		<field type="select" name="e404_object_id" label="������"     description="�������� ������"        class="medium">
			<system:method name="list">name[OBJECTS]added[select="$SITES_HASH.[$form:id].e404_object_id"]tag[option]</system:method>
		</field>
	}
		<field type="text"   name="cache_time"     label="���"        description="����� ����������� (���)" class="short">$SITES_HASH.[$form:id].cache_time</field>
		<field type="text"   name="sort_order"     label="����������" description="������� ����������"      class="short">$SITES_HASH.[$form:id].sort_order</field>
	^if($_iR & 6){
		<field type="hidden" name="action">insert</field>
	}
	^if($_iR & 1){
		<field type="hidden" name="action">update</field>
		<field type="hidden" name="site_id">$form:id</field>
		<field type="hidden" name="where">site_id</field>
	}
		<field type="hidden" name="tables">
			^$.main[m_site]
		</field>
		<field type="hidden" name="cache">sites</field>
	</tab>
	</tabs>
	</form>
}{
	^drawList[
		$.data[$SITES]
		$.names[^table::create{name	id	object
ID	id	
��������	name	
�����	domain	
����� ����	cache_time	
�������� ������	e404_object_id	OBJECTS_HASH
}]
		$.description[
			����: $SITES.lang_id <br />
			����������: $SITES.sort_order
		]
		$.added[
			<field type="hidden" name="where">site_id</field>
			<field type="hidden" name="cache">sites</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_site]
			</field>
		]
		$.where[site_id]
		$.label[Mouse CMS | �����]
	]
}
#end @sites[]

# -----------------------------------------------------------------------------------------------
#                                    ���������� ���������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� ���������
@objects[][_iR;path;is_published;description;name;document_name;window_name;parent_id]
^if(def $form:action){
	^if($form:action eq 'blocks'){$result[
		<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
		label="MOUSE CMS | ������� | ���������� ������� ������� | $OBJECTS_HASH.[$form:id].name ">
		<tabs>
		<tab id="section-1" name="����� ������� $OBJECTS_HASH.[$form:id].name">
			$BLOCK_TO_OBJECT[^getBLOCK_TO_OBJECT[$.where[ m_block_to_object.object_id='$form:id' ]]]
			<field type="none" label="$OBJECTS_HASH.[$form:id].name" description="����� �������">
				<img src="/themes/mouse/icons/16_add_block.gif" title="��������" alt="^BLOCK_TO_OBJECT.count[]" id="add_button" class="input-image" onClick="add_line('blocks')" />
				<br/><br/>
			</field>
			<div id="blocks">
			<br/>Mode: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Sort_order: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Name:<br/>
				$iCount(1)
				^BLOCK_TO_OBJECT.menu{
				<div id="block_to_object_$iCount">
					<input name="mode_$iCount" value="$BLOCK_TO_OBJECT.mode" class="input-text-short"/><input name="sort_order_$iCount" value="$BLOCK_TO_OBJECT.sort_order" class="input-text-short"/><input type="hidden" name="block_id_$iCount" value="$BLOCK_TO_OBJECT.id"/><input name="block_id_${iCount}_title"  value="$BLOCK_TO_OBJECT.name" class="input-text-medium"/><img src="/themes/mouse/icons/16_select.gif"    title="�������"       alt="x" class="input-image" onClick="pickObject('$OBJECTS_HASH.84.full_path?type=blocks&amp^;mode=picker&amp^;elem=block_id_$iCount')" /><img src="/themes/mouse/icons/16_del_block.gif" title="������"        alt="x" class="input-image" onClick="remove_line($iCount)" />
				</div>
				^iCount.inc(1);
				}
			</div>
			<field type="none">
			</field>
		</tab>
		</tabs>
		</form>
	]}
	^if($form:action eq 'edit'){$_iR($_iR + 1) $_sLabel[������������� ]}
	^if($form:action eq 'copy'){$_iR($_iR + 2) $_sLabel[����������� ]}
	^if($form:action eq 'add'){ $_iR($_iR + 4) $_sLabel[���������� ]}
	^if($_iR & 1){
		$path[$OBJECTS_HASH.[$form:id].path]
		$is_published[$OBJECTS_HASH.[$form:id].is_published]
		$description[$OBJECTS_HASH.[$form:id].description]
	}
	^if($_iR & 3){
		$name[$OBJECTS_HASH.[$form:id].name]
		$document_name[$OBJECTS_HASH.[$form:id].document_name]
		$window_name[$OBJECTS_HASH.[$form:id].window_name]
		$parent_id[$OBJECTS_HASH.[$form:id].parent_id]
	}
	^if($_iR & 4){$parent_id[$form:id]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | ������� | $_sLabel | $OBJECTS_HASH.[$form:id].name ">
		<tabs>
			<tab id="section-1" name="��������">
				^if($_iR & 1){
					<field type="none"     name="object_id"     label="ID"           description="ID �������">$OBJECTS_HASH.[$form:id].id</field>
				}
				<field type="text"     name="name"          label="���"          description=" ��� ������� "           class="medium">
					$name
				</field>
				<field type="text"     name="document_name" label="��������"     description=" ��� ��������� "         class="long"  >
					$document_name
				</field>
				<field type="text"     name="window_name"   label="����"         description=" ������� ���: "          class="long"  >
					$window_name
				</field>
				<field type="text"     name="path"          label="����"         description="��� �����/�������� (example, example.html)" class="medium">
					$path
				</field>
				<field type="text"     name="cache_time"    label="���"          description="����� ����������� (���)" class="short" >
					$OBJECTS_HASH.[$form:id].cache_time
				</field>
				<field type="text"     name="sort_order"    label="�������"      description="������� ����������"      class="short" >
					$OBJECTS_HASH.[$form:id].sort_order
				</field>
				<field type="checkbox" name="is_published"  label="������������" description="">$is_published</field>
				<field type="select" name="parent_id"       label="������"       description="������������ ������"     class="medium">
					<option id="0" select="$parent_id">�������� ������������</option>
					<system:method name="list">name[OBJECTS]added[select="$parent_id"]tag[option]</system:method>
				</field>
				<field type="select" name="template_id" label="������" description="������ ������� �������" class="medium">
					<system:method name="list">name[TEMPLATES]added[select="$OBJECTS_HASH.[$form:id].template_id"]tag[option]</system:method>
				</field>
				<field type="textarea" name="description"   label="��������"     description="�������� �������">$description</field>
			</tab>
			<tab id="section-2" name="��������������">
				^if($_iR & 1){
					<field type="none" name="full_path" label="������ ����" description="�� ����� �����">$OBJECTS_HASH.[$form:id].full_path</field>
				}
				<field name="thread_id" label="����� �������" description="" type="none">$OBJECTS_HASH.[$OBJECTS_HASH.[$form:id].thread_id].name</field>
				<field type="checkbox" name="is_show_on_sitemap" label="�����" description="���������� �� ����� �����">$OBJECTS_HASH.[$form:id].is_show_on_sitemap	</field>
				<field type="checkbox" name="is_show_in_menu" label="����" description="���������� � ����">$OBJECTS_HASH.[$form:id].is_show_in_menu</field>
				<field type="text" name="url" label="URL" description="������ ������" class="long">$OBJECTS_HASH.[$form:id].url</field>
				<field type="select" name="site_id" description="���� �������" label="����" class="medium">
					<system:method name="list">name[SITES]added[select="$OBJECTS_HASH.[$form:id].site_id"]tag[option]</system:method>
				</field>
				<field type="select" name="object_type_id" description="��� �������" label="���" class="long">
					<system:method name="list">name[TYPES]added[select="$OBJECTS_HASH.[$form:id].object_type_id"]tag[option]</system:method>
				</field>
				<field type="select" name="data_process_id" description="���������� �������" label="����������" class="medium">
					<option id="0" select="$OBJECTS_HASH.[$form:id].data_process_id">�����������</option>
					<system:method name="list">name[PROCESSES]added[select="$OBJECTS_HASH.[$form:id].data_process_id"]tag[option]</system:method>
				</field>
				<field type="select" name="link_to_object_id" description="��������� ����������, ���������� ���������� �������" label="������"  class="medium">
					<option id="0" select="$OBJECTS_HASH.[$form:id].link_to_object_id">�� ���������</option>
					<system:method name="list">name[OBJECTS]added[select="$OBJECTS_HASH.[$form:id].link_to_object_id"]tag[option]</system:method>
				</field>
			</tab>
			<tab id="section-3" name="��������">
				^if($_iR & 1){
					<field name="dt_update" label="�������" description="���� ���������� ��������������" type="none">$OBJECTS_HASH.[$form:id].dt_update</field>
					<field name="auser_id" label="��������" description="����� ����������������" type="none">$USERS_HASH.[$OBJECTS_HASH.[$form:id].auser_id].name</field>
				}
				$hRights[^getHashRights($OBJECTS_HASH.[$form:id].rights)]
				<field type="checkbox" name="rights_read" label="��������" description="����� �� ���������">$hRights.read</field>
				<field type="checkbox" name="rights_edit" label="������" description="����� �� ���������">$hRights.edit</field>
				<field type="checkbox" name="rights_delete" label="��������" description="����� �� ���������">$hRights.delete</field>
#				<field type="text" name="rights" label="rights" description="����� ���� �� ������" class="short">$OBJECTS_HASH.[$form:id].rights</field>
				<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
				<field type="hidden" name="auser_id">$MAIN:objAuth.user.[$form:id]</field>
				^if($_iR & 6){
					<field type="hidden" name="action">insert</field>
				}
				^if($_iR & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">object_id</field>
				<field type="hidden" name="object_id">$form:id</field>
				}
				<field type="hidden" name="tables">
					^$.main[m_object]
				</field>
				<field type="hidden" name="cache">objects</field>
			</tab>
		</tabs>
	</form>
	}{
		<button image="24_object_blocks.gif"   name="object_blocks"   alt="����� �������" onClick="CopyChecked('$OBJECTS_HASH.80.full_path?type=$form:type&amp^;action=blocks')" />
		^drawList[
			$.data[$OBJECTS]
			$.names[^table::create{name	id	object
ID	id
��������	name
���	object_type_id	TYPES_HASH
������ ����	full_path	
����	site_id	SITES_HASH
��������	parent_id	OBJECTS_HASH
����������	data_process_id	PROCESSES_HASH
������	template_id	TEMPLATES_HASH
����� ����	cache_time
}]
			$.description{
				��� ���������: $_tData.document_name <br />
				������� ���: $_tData.window_name <br />
				��������: $_tData.description <br />
				<hr/>
				����� �������: $OBJECTS_HASH.[$_tData.thread_id].name,
				rights: $_tData.rights, ������� ����������: $_tData.sort_order,
				����: $_tData.path <br/>
				������: 
					^if(^_tData.is_show_on_sitemap.int(0)){SM }
					^if(^_tData.is_show_in_menu.int(0)){Mn }
					^if(^_tData.is_published.int(0)){Pb } 
				�������: $_tData.dt_update <br/>
				��������: $USERS_HASH.[$_tData.auser_id].name <br/>
				^if(def $_tData.url){������-������: $_tData.url }
				^if(^_tData.link_to_object_id.int(0)){����� �������: $_tData.link_to_object_id }
			}
			$.added[
				<field type="hidden" name="cache_time">0</field>
				<field type="hidden" name="where">object_id</field>
				<field type="hidden" name="cache">objects</field>
				<field type="hidden" name="action">delete</field>
				<field type="hidden" name="tables">
					^$.main[m_object]
					^$.connect[m_block_to_object]
				</field>
			]
			$.where[object_id]
			$.label[Mouse CMS | �������]
		]
}


#end @objects[]

# -----------------------------------------------------------------------------------------------
#                                    ���������� �������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� �������
@blocks[]
^if(def $form:action){
	^if($form:action eq 'edit'){$_iR($_iR + 1) $_sLabel[������������� ]}
	^if($form:action eq 'copy'){$_iR($_iR + 2) $_sLabel[����������� ]}
	^if($form:action eq 'add'){ $_iR($_iR + 4) $_sLabel[���������� ]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | ����� | $_sLabel | $BLOCKS_HASH.[$form:id].name ">
		<tabs>
			<tab id="section-1" name="��������">
				^if($_iR & 1){
					<field type="none"  name="block_id" label="ID" description="ID �����">$BLOCKS_HASH.[$form:id].id</field>
				}
				<field type="text"     name="name"          label="���"          description="�������� �����" class="medium">
					$BLOCKS_HASH.[$form:id].name
				</field>
				<field type="checkbox" name="is_published"  label="������������">$BLOCKS_HASH.[$form:id].is_published</field>
				<field type="select" name="data_process_id" label="����������" description="���������� �����">
					<option id="0" select="$BLOCKS_HASH.[$form:id].data_process_id">�����������</option>
					<system:method name="list">name[PROCESSES]added[select="$BLOCKS_HASH.[$form:id].data_process_id"]tag[option]</system:method>
				</field>
				<field type="textarea" name="description"   label="��������"  description="�������� �����" >$BLOCKS_HASH.[$form:id].description</field>
			</tab>
			<tab id="section-2" name="��������������">
				<field type="checkbox" name="is_parsed_manual" label="������ �����">$BLOCKS_HASH.[$form:id].is_parsed_manual</field>
				<field type="checkbox" name="is_shared" label="����� ����">$BLOCKS_HASH.[$form:id].is_parsed_manual</field>
				<field type="textarea" name="attr" label="��������" description="�������� �����">$BLOCKS_HASH.[$form:id].attr</field>
				<field type="select" name="data_type_id" label="������" description="��� ������ �����">
					<system:method name="list">name[DATA_TYPES]added[select="$BLOCKS_HASH.[$form:id].data_type_id"]tag[option]</system:method>
				</field>
			</tab>
			<tab id="section-3" name="������">
				^use[/fckeditor/fckeditor.p]
				$oFCKeditorData[^fckeditor::Init[data]]
				$oFCKeditorData.Height[500]
				$oFCKeditorData.ToolbarSet[Basic]
				$oFCKeditorData.Value[$BLOCKS_HASH.[$form:id].data]
				^oFCKeditorData.Create[]
			</tab>
		</tabs>
		^if($_iR & 6){
					<field type="hidden" name="action">insert</field>
		}
		^if($_iR & 1){
			<field type="hidden" name="action">update</field>
			<field type="hidden" name="where">block_id</field>
			<field type="hidden" name="block_id">$form:id</field>
		}
		<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
		<field type="hidden" name="cache">blocks</field>
		<field type="hidden" name="tables">
			^$.main[m_block]
		</field>
	</form>
}{
$IS_SHARED[
	$.1[$.name[�����]]
	$.0[$.name[]]
]
	^drawList[
		$.data[$BLOCKS]
		$.names[^table::create{name	id	object
ID	id
��������	name
^if($form:mode ne 'picker'){���	is_shared	IS_SHARED
����������	data_process_id	PROCESSES_HASH
��� ������	data_type_id	DATA_TYPES_HASH
}{��������:	description}
}]
		$.description{
			��������: $_tData.description <br/>
			^if($_tData.is_not_empty){�������� ������ <br/>}
			^if($_tData.is_published){����������� <br/>}
			�������: $_tData.dt_update <br/>
			��������: $_tData.attr <br/>
		}
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">block_id</field>
			<field type="hidden" name="cache">blocks</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_block]
				^$.connect[m_block_to_object]
			</field>
		]
		$.where[block_id]
		$.label[Mouse CMS | �����]
	]
}
#end @blocks[]

# -----------------------------------------------------------------------------------------------
#                                    ���������� �������������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� �������������
@process[]
^if(def $form:action){
	^if($form:action eq 'edit'){$_iR($_iR + 1) $_sLabel[������������� ]}
	^if($form:action eq 'copy'){$_iR($_iR + 2) $_sLabel[����������� ]}
	^if($form:action eq 'add'){ $_iR($_iR + 4) $_sLabel[���������� ]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | ����������� | $_sLabel | $PROCESSES_HASH.[$form:id].name ">
	<tabs>
		<tab id="section-1" name="��������">
			^if($_iR & 1){
				<field type="none"  name="data_process_id" label="ID" description="ID �����������">$PROCESSES_HASH.[$form:id].id</field>
			}
			<field type="text" name="name" label="���" description="��� �����������">$PROCESSES_HASH.[$form:id].name</field>
			<field type="text" name="filename" label="�������" description=" ��� ����� �����������">$PROCESSES_HASH.[$form:id].filename</field>
			<field type="text" name="sort_order" label="�������" description="����������">$PROCESSES_HASH.[$form:id].sort_order</field>
			<field type="select" name="data_process_type_id" label="���" description="��� �����������">
				<system:method name="list">name[DATA_PROCESS_TYPES]tag[option]added[select="$PROCESSES_HASH.[$form:id].data_process_type_id"]</system:method>
			</field>
			<field type="textarea" name="description" label="��������" description="���������������� �����������">$PROCESSES_HASH.[$form:id].description</field>
			^if($_iR & 6){
				<field type="hidden" name="action">insert</field>
			}
			^if($_iR & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">data_process_id</field>
				<field type="hidden" name="data_process_id">$form:id</field>
			}
			<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="cache">process</field>
			<field type="hidden" name="tables">
				^$.main[m_data_process]
			</field>
		</tab>
	</tabs>
	</form>
}{
	^drawList[
		$.names[^table::create{name	id	object
ID	id
��������	name
��� �����	filename
��� ������	data_process_type_id	DATA_PROCESS_TYPES_HASH
}]
		$.data[$PROCESSES]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">data_process_id</field>
			<field type="hidden" name="cache">process</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_data_process]
			</field>
		]
		$.where[data_process_id]
		$.description{
			��������: $_tData.description <br/>
			�������: $_tData.dt_update <br/>
		}
		$.label[Mouse CMS | �����������]
	]
}
#end @process[]

# -----------------------------------------------------------------------------------------------
#                                    ���������� ���������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� ���������
@templates[]
^if(def $form:action){
	^if($form:action eq 'edit'){$_iR($_iR + 1) $_sLabel[������������� ]}
	^if($form:action eq 'copy'){$_iR($_iR + 2) $_sLabel[����������� ]}
	^if($form:action eq 'add'){ $_iR($_iR + 4) $_sLabel[���������� ]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | ������� | $_sLabel | $TEMPLATES_HASH.[$form:id].name ">
	<tabs>
		<tab id="section-1" name="��������">
			^if($_iR & 1){
				<field type="none"  name="template_id" label="ID" description="ID �������">$TEMPLATES_HASH.[$form:id].id</field>
			}
			<field type="text" name="name"       label="���"        description="��� �������">$TEMPLATES_HASH.[$form:id].name</field>
			<field type="text" name="filename"   label="������"     description=" ��� ����� �������"  class="medium">$TEMPLATES_HASH.[$form:id].filename</field>
			<field type="text" name="params"     label="���� �����" description=" ��� ����� �����"  class="medium">$TEMPLATES_HASH.[$form:id].params</field>
			<field type="text" name="sort_order" label="�������"    description="����������" class="short">$TEMPLATES_HASH.[$form:id].sort_order</field>
			<field type="textarea" name="description" label="��������" description="���������������� �������">$TEMPLATES_HASH.[$form:id].description</field>
			^if($_iR & 6){
				<field type="hidden" name="action">insert</field>
			}
			^if($_iR & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">template_id</field>
				<field type="hidden" name="template_id">$form:id</field>
			}
			<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="cache">templates</field>
			<field type="hidden" name="tables">
				^$.main[m_template]
			</field>
		</tab>
	</tabs>
	</form>
}{
	^drawList[
		$.names[^table::create{name	id	object
ID	id
��������	name
��� �����	filename
��� ����� �����	params
}]
		$.data[$TEMPLATES]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">template_id</field>
			<field type="hidden" name="cache">templates</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_template]
			</field>
		]
		$.where[template_id]
		$.description{
			��������: $_tData.description <br/>
			�������: $_tData.dt_update <br/>
		}
		$.label[Mouse CMS | �������]
	]
}
#end @templates[]

# -----------------------------------------------------------------------------------------------
#                                    ���������� ��������������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� ��������������
@users[]
^if(def $form:action){
	^if($form:action eq 'edit'){$_iR($_iR + 1) $_sLabel[������������� ]}
	^if($form:action eq 'copy'){$_iR($_iR + 2) $_sLabel[����������� ]}
	^if($form:action eq 'add'){ $_iR($_iR + 4) $_sLabel[���������� ]}
	^if($_iR & 2){$USERS_HASH.[$form:id].name[]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | ������������ � ������ | $_sLabel | $USERS_HASH.[$form:id].name ">
	<tabs>
		<tab id="section-1" name="��������">
			^if($_iR & 1){
				<field type="none"  name="auser_id" label="ID" description="ID ������������" class="short">$USERS_HASH.[$form:id].id</field>
			}
			<field type="text" name="name" label="���" description="��� ������������" class="medium">
				$USERS_HASH.[$form:id].name
			</field>
			<field type="select" name="auser_type_id" label="���" description="��� ������������" class="medium">
				<option value="0" select="$USERS_HASH.[$form:id].auser_type_id">������������</option>
				<option value="1" select="$USERS_HASH.[$form:id].auser_type_id">������</option>
				<option value="2" select="$USERS_HASH.[$form:id].auser_type_id">��������</option>
			</field>
			<field type="text" name="email" label="E-Mail" description="����������� �����" class="medium">$USERS_HASH.[$form:id].email</field>
			<field type="checkbox" name="is_published" label="������������" description="" class="medium">$USERS_HASH.[$form:id].is_published</field>
			<field type="textarea" name="description" label="��������" description="�������� ������������">$USERS_HASH.[$form:id].description</field>
			<field type="text" name="passwd" label="������" description="���������� (�������) ������" class="medium"></field>
		</tab>
		<tab id="section-3" name="��������">
			<field type="select" name="auth_parent_id" label="������" description="������ ������������" class="medium">
				<option value="0" select="$GROUPS_HASH.[$form:id].parent_id">none</option>
				^USERS.menu{^if($USERS.auser_type_id == 1){
					<option value="$USERS.id" select="$GROUPS_HASH.[$form:id].parent_id">$USERS.name</option>
				}}
			</field>
			$hRights[^getHashRights($USERS_HASH.[$form:id].rights)]
			<field type="checkbox" name="rights_read" label="��������" description="����� �� ���������">$hRights.read</field>
			<field type="checkbox" name="rights_edit" label="������" description="����� �� ���������">$hRights.edit</field>
			<field type="checkbox" name="rights_delete" label="��������" description="����� �� ���������">$hRights.delete</field>
			<field type="checkbox" name="rights_comment" label="�����������" description="����� �� ���������">$hRights.comment</field>
			<field type="checkbox" name="rights_supervisory" label="����� ���" description="����� �� ���������">$hRights.supervisory</field>
			^if($_iR & 6){
			<field type="hidden" name="action">insert</field>
			<field type="hidden" name="dt_register">^MAIN:dtNow.sql-string[]</field>
			}
			^if($_iR & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">auser_id</field>
				<field type="hidden" name="auser_id">$form:id</field>
			}
			<field type="hidden" name="cache">users</field>
			<field type="hidden" name="tables">
				^$.main[auser]
			</field>
		</tab>
	</tabs>
	</form>
}{
		^drawList[
		$.names[^table::create{name	id	object
ID	id
���	name
���	auser_type_id	USERS_TYPES_HASH
�����	rights
E-mail	email
����	dt_logon
�����	dt_logout
�������	event_type
}]
		$.data[$USERS]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">auser_id</field>
			<field type="hidden" name="cache">users</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[auser]
				^$.connect[asession]
				^$.connect2[aevent_log]
				^$.connect3[acl]
			</field>
		]
		$.where[auser_id]
		$.description{
			��������: $_tData.description <br/>
			�����������������: $_tData.dt_register <br/>
			��������� ������: $_tData.dt_access <br/>
		}
		$.label[Mouse CMS | ������������ � ������]
	]
}
#end @users[]

# -----------------------------------------------------------------------------------------------
#                                    ���������� �������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ���������� �������
@rights[]
^drawList[
		$.names[^table::create{name	id	object
������	id	OBJECTS_HASH
������������	id	USERS_HASH
�����	rights
}]
		$.data[$ACL]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">auser_id</field>
			<field type="hidden" name="cache">users</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[auser]
				^$.connect[asession]
				^$.connect2[aevent_log]
				^$.connect3[acl]
			</field>
		]
		$.where[auser_id]
		$.label[Mouse CMS | ���������� ������� ]
	]
#end @rights[]

# -----------------------------------------------------------------------------------------------
#                                    ������� �������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ������ ������� ����������� ��������
@config[]
<button image="24_clear.gif"  name="clear"    alt="�������� ���"  onClick="saveForm('form_content','${OBJECTS_HASH.80.full_path}?type=$form:type','#container')" />
<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data" 
label="MOUSE CMS | ������� ������� ">
	<field type="hidden" name="cache">all</field>
	<field type="hidden" name="cache_time">all</field>
</form>
#end @config[]

# -----------------------------------------------------------------------------------------------
#                                    �������� ������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ��������� �����
@files[]
<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | �������� ������ ">
	<tabs>
		<tab id="section-1" name="�������� ������">
			<field type="hidden" name="object_id" />
			<input type="text" name="object_name" class="input-text-medium" />
			<img src="/themes/mouse/icons/16_select.gif"    title="�������" alt="x" class="input-image" onClick="pickObject('$OBJECTS_HASH.84.full_path?type=blocks&amp^;mode=picker&amp^;elem=block_id_$BLOCK_TO_OBJECT.id')" />
		</tab>
	</tabs>
</form>
#end files[]

#################################################################################################
#                                                                                               #
#                                    ����� ������                                               #
#                                                                                               #
#################################################################################################
# -----------------------------------------------------------------------------------------------
#                                  ������ ��������
# -----------------------------------------------------------------------------------------------
#################################################################################################
# ������ ������� ����������� ��������
@drawList[hParams]
^if(def $form:find){$hParams.data[^hParams.data.select(^hParams.data.name.match[$form:find][i])]}
^if(def $form:order){
	^if(^hParams.data.[$form:order].int(0)){
		^hParams.data.sort($hParams.data.[$form:order])
	}{
		^hParams.data.sort{$hParams.data.[$form:order]}
	}
}
^if(def $form:filter){
	$_tParam[$form:filter]
	$_tParam[^_tParam.split[=]]
	$_sParam[^_tParam.piece.trim[]]
	^_tParam.offset(1)
	$hParams.data[^hParams.data.select($hParams.data.[$_sParam] eq ^_tParam.piece.trim[])]
}
$scroller[^scroller::create[
	$.path_param[page]
	$.request[]
	$.table_count(^hParams.data.count[])
	$.number_per_section(^form:number.int(20))
	$.section_per_page(5)
	$.type[page]
	$.r_selector[ next ]
	$.l_selector[ prev ]
	$.divider[ ]
	$.r_divider[^]]
	$.l_divider[^[]
]]
$_tData[^table::create[$hParams.data;$.limit($scroller.limit) $.offset($scroller.offset)]]
<form name="form_content" method="post" action="" label="$hParams.label">
	<button image="24_add.gif"    name="add"    alt="��������"   onClick="Go('$OBJECTS_HASH.80.full_path?type=$form:type&amp^;action=add','#container')" />
	<button image="24_copy.gif"   name="copy"   alt="����������" onClick="CopyChecked('$OBJECTS_HASH.80.full_path?type=$form:type&amp^;action=copy')" />
	<button image="24_delete.gif" name="delete" alt="�������"    onClick="DeleteChecked('$hParams.where','${OBJECTS_HASH.80.full_path}?type=$form:type','#container')" />
<table class="table-builder-spreadsheet">
	<thead class="table-builder-spreadsheet">
		<tr>
   		<td>
   			<div style="padding: 0px; margin: 0px;">
				<input type="checkbox" name="check_main" class="input-checkbox" onClick="checkAll();markAll()" />
				<span style="cursor: default;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}">
				</span>
				</div>
			</td>
			^hParams.names.menu{
			<![CDATA[<th onDblClick="Go('$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'order'){}{$key=$value&}}order=$hParams.names.id', '#container')" id="$hParams.names.id">$hParams.names.name</th>]]>
			}
		</tr>
	</thead>
	<tbody class="table-builder-spreadsheet">
	^_tData.menu{
		<tr id="tr_${_tData.id}"  
			^if($form:mode eq 'picker'){
				onDblClick="setPick('$_tData.id','$_tData.name','$form:elem')"
			}{
				onDblClick="doEdit('$MAIN:sPath?action=edit&amp^;type=$form:type&amp^;id=$_tData.id','#container')"
			}
			>
      		<td>
         		<div style="padding: 0px^; margin: 0px^;">
						<input type="checkbox" name="check_${_tData.id}" class="input-checkbox" onClick="markRow(${_tData.id})" />
						<span style="cursor: default^;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}">
						</span>
					</div>
					^if(def $hParams.description){<div class="div-system-info" id="sysinfo_$_tData.id">^process{$hParams.description}</div>}
				</td>
			^hParams.names.menu{
				<td onClick="doMark(${_tData.id})" >
      			<span onClick="setFilter('$hParams.names.id', '${_tData.[$hParams.names.id]}')" class="arrow" onMouseover="ShowLocate('sysinfo_$_tData.id', event)" onMouseout="Hide('sysinfo_$_tData.id')">
      				^if(def $hParams.names.object){
      					$[$hParams.names.object].[${_tData.[$hParams.names.id]}].name
      				}{
      					${_tData.[$hParams.names.id]}
      				}
      			</span>
				</td>
			}
		</tr>
	}
	</tbody>
	<tfoot class="table-builder-spreadsheet">
		<tr id="space"><td colspan="100"></td></tr>
		<tr id="pages">
			<td colspan="100">
				^scroller.optimize[<div class="scroller">^scroller.draw[]</div>]
			</td>
		</tr>
			<tr id="perpage">
				<td colspan="100">
					<div class="form">
    						<label for="sys-perpage">�������� �� ��������:</label>
    						<input type="text" id="sys-perpage" name="sys_perpage" value="$scroller.limit" class="input-text-short" size="2" />
   						<![CDATA[<input type="button" value="��������" class="input-button" onClick="Go('$SYSTEM.path?^form:fields.foreach[key;value]{^if($key ne 'number'){$key=$value&}}number=' + document.getElementsByName('sys_perpage')[0].value , '#container')" />]]>
					</div>
					<div class="total">����� ����������: $scroller.offset $_iTemp($scroller.offset + $scroller.limit) - $_iTemp (^hParams.data.count[]) </div>
				</td>
			</tr>
			<tr id="search">
				<td colspan="100">
					<div>
						<label for="sys-search">�����:</label>
    					<input type="text" id="sys-search" name="sys_svalue" value="$form:find" class="input-text-long" size="50" />
    					<![CDATA[<input type="button" class="input-button" value="��������" 
						onClick="Go('$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'find' || $key eq 'filter'){}{$key=$value&}}find=' + escape(document.getElementsByName('sys_svalue')[0].value) + '&filter=' + document.getElementsByName('fquery')[0].value, '#container')" />]]>
					</div>
					<div>
    					<label for="sys-filter">������:</label>
    					<input type="text" name="fquery" value="$form:filter" class="input-text-long" size="30" readonly="readonly" />
    					<input type="hidden" name="sys_ffield" value="" />
    					<input type="hidden" name="sys_fvalue" value="" />
    					<img src="/themes/mouse/buttons/clear.gif" alt="x" class="input-image" onClick="clearFilter()" />
    					(����� ���������� ������ ������� �� �������� � �������)
				</div>
			</td>
		</tr>
	</tfoot>
</table>
$hParams.added
</form>
#end @drawList[hParams]
