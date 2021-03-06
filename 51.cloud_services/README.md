# Create Cloud VM Instances (GCP, AWS, Azure...)

## [STEP 1] ansible
### Install
```
sudo yum install epel-release
sudo yum install -y ansible
ansible --version
```

### Set config to ignore ansible SSH authenticity checking
- 생성한 gce instance에 접속하여 작업하기 위해서
- 사용자가 별도의 키보드 입력을 하지 않도록 하기 위함.
- 이 설정을 하지 않으면, 아래와 같이 사용자가 yes/no를 입력해야 함.
```
GATHERING FACTS ***************************************************************
The authenticity of host 'xxx.xxx.xxx.xxx (xxx.xxx.xxx.xxx)' can't be established.
RSA key fingerprint is xx:yy:zz:....
Are you sure you want to continue connecting (yes/no)?
```
- 설정값 변경  
```
> sudo vi /etc/ansible/ansible.cfg

[defaults]
host_key_checking = False
```

## [STEP 2] GCP
### Google Cloud Platform Guide
- https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html
#### Install gcloud sdk
```
> sudo yum install -y python-pip
> sudo pip install --upgrade pip
> sudo pip install  requests google-auth
> sudo yum install -y wget git
> wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-183.0.0-linux-x86_64.tar.gz?hl=ko -O google-cloud-sdk-183.0.0-linux-x86_64.tar.gz
> tar xvf google-cloud-sdk-183.0.0-linux-x86_64.tar.gz\?hl\=ko
> ./google-cloud-sdk/install.sh
```
- google cloud sdk를 설치하면, 아래과 같은 로그가 나타난다.
```
Your current Cloud SDK version is: 183.0.0
The latest available version is: 238.0.0

┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   Components                                                   │
├──────────────────┬──────────────────────────────────────────────────────┬──────────────────────────┬───────────┤
│      Status      │                         Name                         │            ID            │    Size   │
├──────────────────┼──────────────────────────────────────────────────────┼──────────────────────────┼───────────┤
│ Update Available │ BigQuery Command Line Tool                           │ bq                       │   < 1 MiB │
│ Update Available │ Cloud SDK Core Libraries                             │ core                     │   9.7 MiB │
│ Update Available │ Cloud Storage Command Line Tool                      │ gsutil                   │   3.6 MiB │
│ Not Installed    │ App Engine Go Extensions                             │ app-engine-go            │  56.6 MiB │
│ Not Installed    │ Cloud Bigtable Command Line Tool                     │ cbt                      │   6.4 MiB │
│ Not Installed    │ Cloud Bigtable Emulator                              │ bigtable                 │   5.6 MiB │
│ Not Installed    │ Cloud Datalab Command Line Tool                      │ datalab                  │   < 1 MiB │
│ Not Installed    │ Cloud Datastore Emulator                             │ cloud-datastore-emulator │  18.4 MiB │
│ Not Installed    │ Cloud Datastore Emulator (Legacy)                    │ gcd-emulator             │  38.1 MiB │
│ Not Installed    │ Cloud Firestore Emulator                             │ cloud-firestore-emulator │  39.2 MiB │
│ Not Installed    │ Cloud Pub/Sub Emulator                               │ pubsub-emulator          │  33.4 MiB │
│ Not Installed    │ Cloud SQL Proxy                                      │ cloud_sql_proxy          │   3.8 MiB │
│ Not Installed    │ Emulator Reverse Proxy                               │ emulator-reverse-proxy   │  14.5 MiB │
│ Not Installed    │ Google Cloud Build Local Builder                     │ cloud-build-local        │   6.0 MiB │
│ Not Installed    │ Google Container Registry's Docker credential helper │ docker-credential-gcr    │   1.8 MiB │
│ Not Installed    │ gcloud Alpha Commands                                │ alpha                    │   < 1 MiB │
│ Not Installed    │ gcloud Beta Commands                                 │ beta                     │   < 1 MiB │
│ Not Installed    │ gcloud app Java Extensions                           │ app-engine-java          │ 108.8 MiB │
│ Not Installed    │ gcloud app PHP Extensions                            │ app-engine-php           │           │
│ Not Installed    │ gcloud app Python Extensions                         │ app-engine-python        │   6.0 MiB │
│ Not Installed    │ gcloud app Python Extensions (Extra Libraries)       │ app-engine-python-extras │  28.5 MiB │
│ Not Installed    │ kubectl                                              │ kubectl                  │   < 1 MiB │
└──────────────────┴──────────────────────────────────────────────────────┴──────────────────────────┴───────────┘
To install or remove components at your current SDK version [183.0.0], run:
  $ gcloud components install COMPONENT_ID
  $ gcloud components remove COMPONENT_ID

To update your SDK installation to the latest version [238.0.0], run:
  $ gcloud components update
```
#### gcloud를 초기화 하면서, 사용할 service account를 지정한다.
- restart shell (변경사항을 적용하기 위함)
```
> ./google-cloud-sdk/bin/gcloud init
Choose the account you would like to use to perform operations for
this configuration:
 [1] xxxxxxxxx-compute@developer.gserviceaccount.com
 [2] Log in with a new account
Please enter your numeric choice:  1

You are logged in as: [xxxxxx-compute@developer.gserviceaccount.com].

WARNING: Listing available projects failed: HttpError accessing <https://cloudresourcemanager.googleapis.com/v1/projects?filter=lifecycleState%3AACTIVE&alt=json&pageSize=201>: response: <{'status': '403', 'content-length': '138', 'x-xss-protection': '1; mode=block', 'x-content-type-options': 'nosniff', 'transfer-encoding': 'chunked', 'vary': 'Origin, X-Origin, Referer', 'server': 'ESF', 'server-timing': 'gfet4t7; dur=71', '-content-encoding': 'gzip', 'cache-control': 'private', 'date': 'Wed, 13 Mar 2019 05:54:51 GMT', 'x-frame-options': 'SAMEORIGIN', 'content-type': 'application/json; charset=UTF-8', 'www-authenticate': 'Bearer realm="https://accounts.google.com/", error="insufficient_scope", scope="https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/cloud-platform.read-only https://www.googleapis.com/auth/cloudplatformprojects https://www.googleapis.com/auth/cloudplatformprojects.readonly"'}>, content <{
  "error": {
    "code": 403,
    "message": "Request had insufficient authentication scopes.",
    "status": "PERMISSION_DENIED"
  }
}
>
Enter project id you would like to use:  ultra-badxxge-xxxx (project id 입력)

> gcloud components update
ERROR: (gcloud.components.update)
You cannot perform this action because the Cloud SDK component manager
is disabled for this installation. You can run the following command
to achieve the same result for this installation:

> sudo yum makecache && sudo yum update kubectl google-cloud-sdk google-cloud-sdk-app-engine-grpc google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-cloud-build-local google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator google-cloud-sdk-datalab google-cloud-sdk-app-engine-java
```

#### Test gcloud Command
```
# gce instance 목록 확인
> gcloud compute instances list

# gce instance 생성
> gcloud compute instances create example-instance-1 example-instance-2 example-instance-3 --zone us-central1-a

# gce ip 목록 확인
> gcloud compute addresses list

# gce 고정 ip 생성 (global 옵션)
> gcloud compute addresses create myaddress us-central1-a --global
```






## [STEP 4] ansible + gce
### Create GCP Service Account
- ansible에서 gce instance 등을 생성할 수 있는 인증서 필요
- Copy service account key files to ansible server
#### IAM > Service Account > Create Service Account 생성
- 위 메뉴에서 Service account를 생성하고,
- 생성된 service account의 private key를 다운로드 받는다. (json 포맷)
  - gcloud command로 gcp 자원을 관리하기 위한 용도록 사용. (gcloud 실행시 key 파일의 경로 지정)

#### Copy  key file to ansible server
- 만약 위에서 다운받은 key 파일이 ansible 서버로 저장되었다면, 아래의 작업은 필요없음
- key를 저장한 서버에서 ansible를 실행할 서버로 전달
```
> scp -i ~/.ssh/freepsw_sk mypjt-default-pjt-xxx.json freepsw@104.196.xxx.xxx:~/.ssh/
```

### Ansible script Examples
- https://github.com/GoogleCloudPlatform/compute-video-demo-ansible.git
- 위 코드를 참고하여 테스트를 진행함.
- 주요 내용은
  - 고정IP 생성
  - VM Instance 생성
  - VM과 고정 IP 매핑
  - VM Instance에 apache web server 설
  - Apache module (mod_headers) 설치
  - index.html 수정
  - apache config 수정
  - apache web 실행
- 사용자는 해당 vm server에 http로 접속만 하면 됨.  

#### Edit GCE configuration
- 테스트를 위해 잘 정리된 github repository가 있어서 이를 활용한다. 
- 일단 git project를 다운받는다.
```
> git clone https://github.com/GoogleCloudPlatform/compute-video-demo-ansible.git
```

##### 1) server user & ssh key 정보 입력
- gce에 필요한 설정정보를 변경
- vm instance에 접속하기 위한 ssh key관련 정보
```
> vi compute-video-demo-ansible/group_vars/all

---
ansible_ssh_user: username
ansible_ssh_private_key_file: /home/username/.ssh/gcp-vm-key-file
```

##### 2) Edit GCE configuration (project_id, service account key)
- gce 서비스를 사용하기 위한 정보 (위에서 IAM으로 생성한 정보)
- 위에서 생성한 key 파일의 경로를 입력한다.
```
> vi compute-video-demo-ansible/gce_vars/auth

project: <프로젝트 ID>
credentials_file: ~/.ssh/test_pjt-f6355b94fa61.json
auth_kind: serviceaccount
```

#### Run Script
```
> ansible-playbook -i ansible_hosts site-one.yml
```
