# Check Process Execution Time / CPETIME       

![image](https://user-images.githubusercontent.com/61023717/178011280-4c75dad1-45c9-4386-afc2-2ed53f5f6a23.png)

AUTOR: Daniel Martins / daniel.martins@opservices.com                           
CRIADO EM: 29/06/2022 13:37:37                                                  

 ------------------------------------------------------------------------
 
 Esse script coleta a quantidade de horas que um processo do Windows está em    
 execução  e gera um alerta conforme o threshold.
 
 Solicita argumentos. Exemplo: .\check_process_executiontime.ps1 processo 24 
 Irá checar se o processo está rodando a mais de 24 horas ou não.
 Pode ser valor decimal, Ex: .\check_process_executiontime.ps1 notepad 2.4
 
 Saídas configuradas no padrão nagios, testado com agente NRPE.
