# TPC DS Benchmark 사용법
## Install TPC DS Benchmark tools
### Download
```
# 1) github에서 다운받는 방법
> sudo yum install gcc make flex bison byacc git

# 2) tpc official site에서 다운받는 방법
# http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp
# 한번만 다운로드 가능함
```

### Install tpc tools
```
> git clone https://github.com/gregrahn/tpcds-kit.git
> cd tpcds-kit/tools
> make OS=LINUX
> ./dsdgen --help

```

## Generate data
- dir : 생성된 데이터를 저장할 경로
- scale : 데이터 사이즈 (GB 단 )
```
> ./dsdgen -scale 1 -dir ~/tpc-data/

# 아래와 같이 생성된 데이터가 보임
> ls ~/tpc-data
call_center.dat       customer.dat                income_band.dat  ship_mode.dat      warehouse.dat
catalog_page.dat      customer_demographics.dat   inventory.dat    store.dat          web_page.dat
catalog_returns.dat   date_dim.dat                item.dat         store_returns.dat  web_returns.dat
catalog_sales.dat     dbgen_version.dat           promotion.dat    store_sales.dat    web_sales.dat
customer_address.dat  household_demographics.dat  reason.dat       time_dim.dat       web_site.dat
```
