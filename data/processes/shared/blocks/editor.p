^rem{	вывод формы	}
<body>
	<block mode="1">
		<block_content>
			<html>
				<head>
					<title>Редактор</title>
				</head>
				<body>
					^use[/fckeditor/fckeditor.p]
					$oFCKeditor[^fckeditor::Init[text1]]
					$oFCKeditor.BasePath[/fckeditor/]
					$oFCKeditor.Value[Текст по умолчанию]
					^oFCKeditor.Create[]
				</body>
			</html>
		</block_content>
	</block>
</body>