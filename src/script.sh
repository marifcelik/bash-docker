#!/bin/bash

# sonrasında duruma göre atamak ve kontrol etmek için değişkenleri tanımlıyorum
reg=""
con_name=""
mem_usg=""
cpu_usg=""

tag="$(whoami)"
mode=""
cmd="docker"

# --help girildiğinde basılacak kısım
usage() {
    echo "    Usage:
    --mode              Select mode <build|deploy|template> 
    --image-name        Docker image name
    --image-tag         Docker image tag
    --memory            Container memory limit
    --cpu               Container cpu limit
    --container-name    Container name
    --registry         DocherHub or GitLab Image registery
    --application-name  Run mysql or mongo server
"
    exit
}


# --help veya boş girilmesi durumunu kontrol ediyorum
if [[ $1 == "--help" ]] || [[ $# == 0 ]]
then
    usage
fi

# her durumda --mode belirtilmesi gerekiyor
if [[ $1 != "--mode" ]]
then
    echo "error missing argument : '--mode'"
    exit 1
fi


# girilen argümanları liste olarak alıp liste elemanları olduğu sürece
# işlem yapıyorum
while (( "$#" ))
do
    # her argüman için argümandan hemen sonra gelen değerleri kontrol ediyor ve atama yapıyorum
    case $1 in
        --mode )
            mode="$2"
            
            # girilen farklı modlar için çalıştırılacak komutu belirliyorum
            if [[ $2 == "build" ]]
            then
                # zorunlu olan argümanlar yoksa hata mesajı basıyorum
                if [[ $3 != "--image_name" ]] || [[ $5 != "--image_tag" ]]
                then
                    echo 'error missing argument'
                    exit 1
                fi
                # her bir mode için yukarıda tanımladığım cmd değişkenine gereken eklemeleri yapıyorum
                cmd="${cmd} build"
            elif [[ $2 == "deploy" ]]
            then
                if [[ $3 != "--image_name" ]] || [[ $5 != "--image_tag" ]]
                then
                    echo 'error missing argument'
                    exit 1
                fi
                cmd="${cmd} run -p 9393:8080"
            
            # template i yapamadım | vaktim yetmedi
            elif [[ $2 == "template" ]]
            then
                if [[ $3 != "--application_name" ]]
                then
                    echo 'missing argument'
                    exit 1
                fi
            else
                echo 'error : unexpected parameter'
                exit 1
            fi
            # her case işlemi sonrasında argümanlar dizisinin başından 2 elemanı koparıyorum
            # böylece dizideki argümanları ve aldıkları parametreleri devamlı kontrol edebiliyorum
            shift 2
            ;;

        --image_name )
            # image name in verilip verilmediğini kontrol ediyorum
            if [ -z "$2" ]
            then
                echo "missing parameter '--image_name'"
                exit 1
            fi
            # üstte belirttiğim image tagine gerekli eklemeleri yapıyorum
            tag="${tag}/$2"
            shift 2
            ;;

        --image_tag )
            # diğer case ler ile aynı işlemler
            if [ -z "$2" ]
            then
                echo "missing parameter '--image_tag'"
                exit 1
            fi
            tag="${tag}:$2"
            shift 2
            ;;

        --registry )
            if [ -z "$2" ]
            then
                echo "boş değer girildiğinden docker hub kullanılacak"
                shift
            else
                reg="docker push ${2}/$tag"
                shift 2
            fi
            ;;

        --container-name )
            # bu değişkenleri ilk başta boş olarak atamıştım. eğer kullanıcı bu tag ı belirtmişse yeniden atanacak
            con_name="-n $2"
            shift 2
            ;;

        --memory )
            mem_usg="--memory=$2"
            shift 2
            ;;

        --cpu )
            cpu_usg="--cpus=$2"
            shift 2
            ;;

    esac
done


# burda tekrardan mod kontrolü yapıyor ve ona göre komutları çalıştırıyorum
# ilk kontrol ettiğim true dönerse && den sonraki kod çalışacaktır
[[ $mode == "build" ]] && ${cmd} -t ${tag} && $reg

# deploy seçildiğinde docker komutu syntax a uygun şekilde çalıştırılıyor
[[ $mode == "deploy" ]] && ${cmd} ${con_name} ${mem_usg} ${cpu_usg} ${tag} 

#yetiştiremedim :(
[[ $mode == "template" ]] && echo 'templaten komutu'

