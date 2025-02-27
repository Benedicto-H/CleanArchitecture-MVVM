# CleanArchitecture-MVVM

## 🎯 개요
**GitHub API를 활용하여 Clean Architecture 학습하기**

<br>

## 📖 학습 포인트
- Clean Architecture
- SOLID Principles

<br>

## Clean Architecture
![CleanArchitecture+MVVM](https://github.com/user-attachments/assets/a459c892-ae38-41b4-9de8-952591e288ef)

Clean Architecture는 소프트웨어 설계의 _**'유지보수성, 확장성, 테스트 용이성'**_ 을 높이기 위한 아키텍처 패턴으로, 애플리케이션에는 여러 계층이 있다. <br>
Clean Architecture의 궁극적 목표는 _**'애플리케이션의 비즈니스 로직 (핵심 부분)을 외부의 변화 (UI, 데이터베이스, 외부 API 등)로부터 분리하여, 비즈니스 로직이 외부의 변화에 영향을 받지 않도록 만드는 것!'**_

  ### Clean Architecture의 주요 원칙
  - 의존성 규칙 (Dependency Rule): 내부의 중요한 비즈니스 로직은 외부로부터 의존성을 받지 않으며, 외부에서 내부로만 의존할 수 있다.
    <br>
    
    > 즉, 의존 관계는 _**항상 안쪽으로 향하며, 안쪽에 있는 요소들은 바깥쪽에 있는 요소의 존재를 모른다.**_ -> (**이게 Clean Architecture의 핵심!**)
    > 
    > 안쪽 Circle일수록 고수준 모듈 (High-level module)이며, 바깥쪽 Circle일수록 저수준 모듈 (Low-level module)
  
  - 레이어화 (Layering): 여러 개의 **계층 (Layer)** 으로 구분되며, 각 계층은 역할에 맞는 책임을 수행한다. 가장 중요한 핵심 비즈니스 로직이 중심에 위치하고, 점점 바깥쪽으로 갈수록 시스템의 세부적인 구현 (외부와의 상호작용)이 배치된다.

<br>

## Layers
- **Domain Layer** = Entities + Use Cases + Repositories Interfaces
- **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB
- **Presentation Layer (MVVM)** = ViewModels + Views

  ### Dependency Direction
  ![CleanArchitectureDependencies](https://github.com/user-attachments/assets/cc1555ce-daf8-4b94-85c9-a3d874b4564e)

  - **도메인 계층**은 가장 안쪽 원에 해당되며, 다른 계층에 대한 종속성 없이 완전히 격리됨.
    <br>
    
    Domain Layer에는 _**'Entities(Business Models)', 'Use Cases', 'Repository Interfaces'가 포함된다.**_ <br>
    도메인 계층은 잠재적으로 다른 프로젝트 내에서 재사용될 수 있으며, 이러한 분리를 통해 **종속성 (3rd party 포함)이 필요하지 않기** 때문에 테스트 대상 내에서 호스트 앱을 사용하지 않아도 된다.
  
    > **Note:** 도메인 계층은 다른 계층(예: 프레젠테이션 — UIKit 또는 SwiftUI 또는 데이터 계층 — 매핑 Codable) 의 어떤 것도 포함해서는 안 된다.
    >
    > - **Entities:** 서비스에 사용되어지는 원천 **데이터 모델**
    > - **Use Cases:** Entities를 활용하여 시스템의 목적에 맞는 행동인 **비즈니스 로직 (이하 B.L)**
    > - **Interfaces:** Repository 패턴을 통해 데이터 접근을 추상화하고, **의존성 역전**을 적용하여 비즈니스 로직이 데이터 소스 (API, 로컬 DB 등) 구현에 의존하지 않도록 돕는 역할
    
    <br>
    
  - **데이터 계층**은 _**'저장소 구현 (Repository Implementations)'과 '하나 이상의 데이터 소스 (Data Sources)'가 포함된다.**_
    <br>
    
    데이터 소스는 원격 (Remote) 또는 로컬 (Local, ex. persistent database)일 수 있고, <br>
    여기서 중요한 점은 Data Layer는 _**'도메인 계층에만 의존'한다!**_ (=> _"Data Layer **depends only** on the **Domain Layer.**"_)
    
    > **Note:** 데이터 계층에서 Network JSON 데이터 (e.g. Decodable conformance)의 Mapping을 Domain Models에 추가할 수도 있다.
    
    <br>
    
  - **프레젠테이션 계층**은 _**UI (UIViewController or SwiftUI View)가 포함된다.**_
    <br>
    
    뷰는 _**하나 이상의 Use Cases**_ 에 의해 화면을 조정되며, Presentation Layer는 _**'도메인 계층에만 의존'한다!**_ (=> _"Presentation Layer **depends only** on the **Domain Layer.**"_)
    
    <br>
    
  ### Data Flow
  ![CleanArchitectureDependenciesDataFlow](https://github.com/user-attachments/assets/9f0739f8-942d-4e68-b5df-1d26f41bfa32)

  > 그래프에서 각 계층의 모든 구성 요소는 **종속성 방향**과 **데이터 흐름 (요청/응답)**이 함께 표시됨.
  >
  > 또한, protocol을 이용한 Repository interfaces를 통해 종속성 역전을 볼 수 있다. (=> _"We can see the **Dependency Inversion** point where we use Repository interfaces(protocols)."_)

  <br>

  #### 데이터 흐름
  1. **View** (UI)는 **ViewModel** (Presenter)에서 메서드를 호출.
     > _"**View**(UI) calls method from **ViewModel** (Presenter)."_
  2. **ViewModel은 Use Case를** 실행.
     > _"*ViewModel** executes **Use Case**."_
  3. **Use Case**는 **User**와 **Repositories**의 데이터를 결합.
     > _"**Use Case** combines data from **User** and **Repositories**."_
  4. 각 **Repository**는 **원격 저장소 (Network)**, **영속적인 DB (Persistent DB)** 스토리지 소스 또는 메모리 데이터 (원격 또는 캐시)에서 데이터를 반환.
     > _"Each **Repository** returns data from a **Remote Data** (Network), **Persistent DB** Storage Source or In-memory Data (Remote or Cached)."_
  5. 한 쪽 방향으로 흐른 flow는 다시 반대 방향으로 흘러 **View**를 구성.
     > _"Information flows back to the **View**(UI) where we display the list of items."_
