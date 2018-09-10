#'@name coordinates
#'@aliases coordinates
#'
#'@title Coordinates (SRS)
#'
#'@description Dataframe with all the posible Spatial Reference Systems (SRS) availables
#'to query the Catastro API.
#'
#'@usage coordinates
#'
#'@references
#'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR_Distancia
#'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_CPMRC
#'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR
#'
#'@export

coordinates <- c('EPSG:4230',	
                 'EPSG:4326',	#google
                 'EPSG:4258',	#oficial europeo
                 'EPSG:32627',
                 'EPSG:32628',
                 'EPSG:32629',
                 'EPSG:32630',
                 'EPSG:32631',
                 'EPSG:25829',
                 'EPSG:25830',
                 'EPSG:25831',
                 'EPSG:23029',
                 'EPSG:23030',
                 'EPSG:23031')

coordinates <- data.frame(coordinates)