##################################################################################
#                                                                                #
##################################################################################
#                          Check_Process_Execution_Time                          #
##################################################################################
#                                                                                #
# AUTOR: Daniel Martins / daniel.martins@opservices.com                          #
# CRIADO EM: 29/06/2022 13:37:37                                                 #
#                                                                                #
# REVISÕES:                                                                      #
# --------------------------------------------------------------                 #
#                                                                                #
# v1.1 - 07/07/2022 13:37:37                                                     #
#                                                                                #
#  - Foi implementada melhoria para que funcionasse com números decimais e       # 
# também calculasse  corretamente em casos em que são abertos mais de um         #
# processo no Windows.                                                           #                              
#                                                                                #
#                                                                                #
##################################################################################
#                                                                                #
# Esse script coleta a quantidade de horas que um processo do Windows está em    #
# execução  e gera um alerta conforme o threshold.                               #
#                                                                                #
##################################################################################   

# Solicita argumentos. Exemplo: .\check_process_executiontime.ps1 processo 24 
# Irá checar se o processo está rodando a mais de 24 horas ou não. 
# Pode ser valor decimal, Ex: .\check_process_executiontime.ps1 notepad 2.4      

[CmdletBinding()] 

Param (
	[string]$process,
	[float]$horas
)

# Função para limpeza dos arquivos temporários

function Clear-Temp-Files {
	rm C:\finalhourscount_cpetime_custom_output.txt -Recurse -Force
	rm C:\finalminutescount_cpetime_custom_output.txt -Recurse -Force
	rm C:\output_cpetime_custom_output.txt -Recurse -Force
	rm C:\output2_cpetime_custom_output.txt -Recurse -Force
	rm C:\temp_cpetime_custom_output.txt -Recurse -Force
	rm C:\temp2_cpetime_custom_output.txt -Recurse -Force
}

# Declaração de variáveis e cálculo do startTime do processo  - Get Date

$firstStartTime = $null
$firstStartTime = (Get-Process -Name $process | Select-Object -ExpandProperty StartTime -First 1 | Sort-Object -Unique)
$dataAtual = (Get-Date)
$coletaHorasDeExecucao = (New-TimeSpan -Start $firstStartTime -End $dataAtual | findstr /b "Hours" |Set-Content C:\output_cpetime_custom_output.txt)
$coletaMinutosDeExecucao = (New-TimeSpan -Start $firstStartTime -End $dataAtual | findstr /b "Minutes" |Set-Content C:\temp_cpetime_custom_output.txt)

# Valida se os parâmetros recebidos são válidos e se estão corretos

if ($firstStartTime -eq $null){
	
	write-host "UNKNOWN: Nao foi possivel localizar o processo '$process.exe', favor verificar."
	exit 3
	
}

# Manipula e exibe os números

$formataHorasDeExecucao = (Get-Content C:\output_cpetime_custom_output.txt |ForEach-Object {$_ -replace '\D',''} |Set-Content C:\output2_cpetime_custom_output.txt)
$formataMinutosDeExecucao = (Get-Content C:\temp_cpetime_custom_output.txt |ForEach-Object {$_ -replace '\D',''} |Set-Content C:\temp2_cpetime_custom_output.txt)

$finalhourscount = (Get-Content C:\output2_cpetime_custom_output.txt | ForEach-Object {$_ -replace '\D',''} |Set-Content C:\finalhourscount_cpetime_custom_output.txt)
$finalminutescount = (Get-Content C:\temp2_cpetime_custom_output.txt | ForEach-Object {$_ -replace '\D',''} |Set-Content C:\finalminutescount_cpetime_custom_output.txt)

[float]$exibeHorasEmExecucao = (cat C:\finalhourscount_cpetime_custom_output.txt)
[float]$exibeMinutosEmExecucao = (cat C:\finalminutescount_cpetime_custom_output.txt)
[float]$horas_minutos = "$exibeHorasEmExecucao"+"."+"$exibeMinutosEmExecucao"

# Faz o cálculo e alerta conforme o threshold definido.

if ($horas_minutos -ge $horas) {

	write-host "CRITICAL: O processo '$process.exe' esta a $exibeHorasEmExecucao horas e $exibeMinutosEmExecucao minutos rodando."
	Clear-Temp-Files
	exit 2
	
} elseif ($horas_minutos -lt $horas) {

	write-host "OK: O processo '$process.exe' esta a $exibeHorasEmExecucao horas e $exibeMinutosEmExecucao minutos rodando."
	Clear-Temp-Files
	exit 0
	
} else {
	
	write-host "UNKNOWN: Erro desconhecido no processo '$process.exe'."
	Clear-Temp-Files
	exit 3
	
}
