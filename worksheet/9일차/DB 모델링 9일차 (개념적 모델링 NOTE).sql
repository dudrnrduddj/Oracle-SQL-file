/*
DB 모델링 개요
 - 개념적 모델링 :
     요구분석 단계에서 정의된 핵심 개체와 그들 간의 관계를 바탕으로 ERD를 생성하는 단계
 - 논리적 모델링 :
     개념 설계에서 추상화된 데이터를 구체화하여 개체, 속성을 테이블화하고 상세화 하는 과정
 - 물리적 모델링 :
     논리적 설계 단계에서 표현된 데이터(ERD)를 실제 컴퓨터의 저장장치에 어떻게 표현할 것인가
     (관계형 데이터베이스로 전환)

 
 DB 모델링의 주요 개념
  - 엔티티(Entity) : 
      업무의 관심 대상이 되는 정보를 갖고 있거나 그에 대한 정보를 관리할
      필요가 있는 유형, 무형의 사물(개체)
  - 속성(Attribute) :
      엔티티에서 관리해야 할 최소 단위 정보 항목(관심이 있는 항목)을 말하며 엔티티는 하나 이상
      의 속성을 포함 
  - 인스턴스(Instance) :
      엔티티의 속성으로 실제로 구현된 하나의 값


  - 관계(Relationship) : 
      두 엔티티 사이의 관련성을 나타냄
      
  - 카디널리티(Cardinality) :
      - 각 엔티티에 속해 있는 인스턴스들 간에 수적으로 어떤 관계에 있는 지를 나타냄
      - 종류로는 1:1, 1:N, M:N의 관계가 있다.
      
  - 주식별자(Primary Identifier) :
      - 엔티티 내 각 인스턴스를 구별하는 기준이 되는 속성
      - 주식별자는 하나가 아닌 여러 속성일 수 있다. (복합키)
        --> 복합키의 경우 두 키의 값중 하나만 동일하다면 다른 값을 의미하게 됨. 즉, 두 값 모두 같은 값이어야 중복으로 여겨짐.
      
  - 외래식별자(Foreign Identifier) :
      - 관계가 있는 엔티티 간의 연결고리 역할을 하는 속성
      - 부모의 주식별자와 공통 속성이 자식에게도 존재하면 해당 속성을 외래식별자로 지정.
      - 존재하지 않으면 부모의 주식별자 속성을 자식에게 추가한 후 외래식별자로 지정.
*/


/*
  개념적 모델링
  
    - 엔티티 도출 :
      업무 분석 단계 이후, 분석 자료(업무 기술서, 인터뷰 자료, 장부와 전표 등…)들로부터
      엔티티 도출
       ->엔티티, 속성을 잘 구분하여 도출
    
    - ERD 표기법 (관계)
    
      ERD란, 개체 관계도라고도 불리며 요구분석사항에서 얻어낸 엔티티와 속성들을
      그림으로 그려내어 그 관계를 도출한 것

    - 카디널리티오 참여도에 따른 관계의 종류 :
       ONE - 필수
       MANY -필수
       ONE - 선택
       MANY - 선택

    - 1:1 관계 :
       X에 속하는 하나의 인스턴스는 Y에 속하는 하나의 인스턴스에만 연결되며, 
       Y에 속하는 하나의 인스턴스도 X에 속하는 하나의 인스턴스에만 연결될 때

    - 1:N 관계 :
       X에 속하는 하나의 인스턴스는 Y에 속하는 여러 인스턴스에 연결되며,
       Y에 속하는 하나의 인스턴스는 X에 속하는 하나의 인스턴스만 연결될 때
    
    - M:N :
       X에 속하는 한 인스턴스는 Y에 속하는 여러 인스턴스와 연결될 수 있으며, 
       Y에 속하는 한 인스턴스도 X에 속하는 여러 인스턴스와 연결될 수 있을 때
    
    * M:N 관계는 덜 완성된 모습으로 데이터 구조에 있어서 어떠한 실제적 방법으로도 구현이 불가능하
      다. (따라서 M:N관계는 해소해 주어야 한다.)

     - 식별 관계(Identifying Relationship) :
       - 1:N 관계에서 외래 식별자가 자식 엔티티의 주식별자의 일부가 되는 관계
       - PFK로 표시된다. (외래 식별자가 주식별자의 역할도 한다.)
       - 실선으로 관계를 표시한다.
    
    --> 자식 엔티티가 부모 엔티티와의 관계를 나타내기 위해 부모 엔티티의 기본 키를 자신의 주식별자에 포함시키는 관계를 의미한다.
        이로 인해 자식 엔티티는 부모 엔티티와의 연결을 유지하면서도 자신만의 고유한 식별자를 가질 수 있다.
        왜냐하면 두 컬럼의 복합키에 의해 하나의 컬럼만이 부모의 외래키이자 자신의 기본키 역할을 하게 되면 부모와의 관계를 생성함과 동시에 자신의 고유함을 유지할 수 있게 된다.
        
     - 비식별 관계(Non-Identifying Relationship)
       - 1:N 관계에서 외래 식별자(자신)가 자식 엔티티(자신)의 주식별자 역할을 하지 못하고 단순히 새로운 속성으로 추가되는 관계
       - FK로 표시된다. (단지 외래식별자의 역할만 한다.)
       - 점선으로 관계를 표시한다.


*/




