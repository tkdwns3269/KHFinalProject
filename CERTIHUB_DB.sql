DROP TABLE REPORT;
DROP TABLE APPLY_LOG;
DROP TABLE REPORT_TYPE;
DROP TABLE BOARD_LIKE_LOG;
DROP TABLE BOARD_HATE_LOG;
DROP TABLE MEMBER_CALENDAR;
DROP TABLE MENTOR_LIKE_LOG;
DROP TABLE ALERT;
DROP TABLE MEMBER_TALKROOM;
DROP TABLE MEMBER_LICENSE;
DROP TABLE MEMBER_LOOK_LICENSE;
DROP TABLE COMPILER_LOG;
DROP TABLE DATA_BOARD_ATTACH;
DROP TABLE DATA_BOARD;
DROP TABLE REPLY;
DROP TABLE BOARD_IMG;
DROP TABLE STUDY_BOARD;
DROP TABLE BOARD;
DROP TABLE STUDY_MEMBER;
DROP TABLE MESSAGE;
DROP TABLE TALKROOM;
DROP TABLE STUDY;
DROP TABLE MEMBER;
DROP TABLE BOARD_TAB;
DROP TABLE LICENSE;
DROP TABLE CHATBOT_LOG;
--DROP TABLE CALENDAR;

DROP SEQUENCE BOARD_TAB_SEQ;
DROP SEQUENCE BOARD_SEQ;
DROP SEQUENCE BOARD_IMG_SEQ;
DROP SEQUENCE REPLY_SEQ;
DROP SEQUENCE LICENSE_SEQ;
DROP SEQUENCE MEMBER_SEQ;
DROP SEQUENCE STUDY_SEQ;
DROP SEQUENCE STUDY_BOARD_SEQ;
DROP SEQUENCE REPORT_SEQ;
DROP SEQUENCE REPORT_TYPE_SEQ;
DROP SEQUENCE COMPILE_SEQ;
DROP SEQUENCE MENTOR_LIKE_LOG_SEQ;
DROP SEQUENCE ALERT_SEQ;
DROP SEQUENCE TALKROOM_SEQ;
DROP SEQUENCE MESSAGE_SEQ;
DROP SEQUENCE DATA_BOARD_ATT_SEQ;
DROP SEQUENCE DATA_BOARD_SEQ;
DROP SEQUENCE APPLY_LOG_SEQ;
DROP SEQUENCE CHATBOT_LOG_SEQ;

-- 테이블 생성

CREATE TABLE BOARD_TAB(
    TAB_NO NUMBER,
    TAB_NAME VARCHAR2(60),
    CONSTRAINT BTAB_TNO_PK PRIMARY KEY(TAB_NO)
);

COMMENT ON COLUMN BOARD_TAB.TAB_NO IS '탭번호';
COMMENT ON COLUMN BOARD_TAB.TAB_NAME IS '탭이름';

CREATE TABLE LICENSE(
    LICENSE_NO NUMBER,
    LICENSE_NAME VARCHAR2(150) NOT NULL,
    LICENSE_DESC VARCHAR2(3000),
    CONSTRAINT L_LNO_PK PRIMARY KEY(LICENSE_NO)
);

COMMENT ON COLUMN LICENSE.LICENSE_NO IS '자격증번호';
COMMENT ON COLUMN LICENSE.LICENSE_NAME IS '자격증이름';
COMMENT ON COLUMN LICENSE.LICENSE_DESC IS '자격증설명';

CREATE TABLE MEMBER(
    MEMBER_NO NUMBER,
    MEMBER_ID VARCHAR2(60) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(300) NOT NULL,
    MEMBER_NAME VARCHAR2(60) NOT NULL,
    MEMBER_INTRO VARCHAR2(300),
    MEMBER_NICKNAME VARCHAR2(60) NOT NULL UNIQUE,
    EMAIL VARCHAR2(100) NOT NULL,
    PHONE VARCHAR2(30) NOT NULL,
    MEMBER_IMG VARCHAR2(300) DEFAULT '/resources/static/img/profile/default_profile.png' NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,
    STATUS VARCHAR2(3) DEFAULT 'Y' CHECK( STATUS IN ('Y','N')),
    MANAGER_STATUS VARCHAR2(3) DEFAULT 'N' NOT NULL CHECK( MANAGER_STATUS IN ('Y','N')),
    MENTOR_STATUS VARCHAR2(3) DEFAULT 'N' NOT NULL CHECK( MENTOR_STATUS IN ('Y','N')),
    MENTOR_VALID VARCHAR2(3) DEFAULT 'N' NOT NULL CHECK( MENTOR_VALID IN ('Y','N')),
    MENTOR_INTRO VARCHAR2(1000),
    CAREER VARCHAR2(600),
    CONSTRAINT M_MNO_PK PRIMARY KEY(MEMBER_NO)
);

COMMENT ON COLUMN MEMBER.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '멤버아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '멤버비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '멤버실제이름';
COMMENT ON COLUMN MEMBER.MEMBER_INTRO IS '멤버자기소개';
COMMENT ON COLUMN MEMBER.MEMBER_NICKNAME IS '멤버닉네임';
COMMENT ON COLUMN MEMBER.EMAIL IS '멤버이메일';
COMMENT ON COLUMN MEMBER.PHONE IS '멤버전화번호';
COMMENT ON COLUMN MEMBER.MEMBER_IMG IS '프로필사진';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '멤버가입일';
COMMENT ON COLUMN MEMBER.STATUS IS '탈퇴여부(Y/N)';
COMMENT ON COLUMN MEMBER.MANAGER_STATUS IS '관리자여부(Y/N)';
COMMENT ON COLUMN MEMBER.MENTOR_STATUS IS '멘토여부(Y/N)'; -- 관리자가 멘토 부여
COMMENT ON COLUMN MEMBER.MENTOR_VALID IS '멘토활동여부(Y/N)'; -- 멘토인 유저가 임의로 변경 가능
COMMENT ON COLUMN MEMBER.MENTOR_INTRO IS '멘토소개';
COMMENT ON COLUMN MEMBER.CAREER IS '멘토경력';

CREATE TABLE STUDY(
    STUDY_NO NUMBER,
    MANAGER_NO NUMBER NOT NULL,
    STUDY_NAME VARCHAR2(90) NOT NULL,
    STUDY_INFO VARCHAR2(3000),
    STUDY_IMG VARCHAR2(300) DEFAULT '/resources/static/img/studyProfile/default_profile.png' NOT NULL,
    STUDY_RECRUIT VARCHAR2(3) DEFAULT 'N' NOT NULL CHECK(STUDY_RECRUIT IN('Y','N')),
    CONSTRAINT S_SNO_PK PRIMARY KEY(STUDY_NO),
    CONSTRAINT S_MGNO_FK FOREIGN KEY(MANAGER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN STUDY.STUDY_NO IS '스터디그룹번호';
COMMENT ON COLUMN STUDY.MANAGER_NO IS '관리자번호';
COMMENT ON COLUMN STUDY.STUDY_INFO IS '스터디소개글';
COMMENT ON COLUMN STUDY.STUDY_IMG IS '스터디프로필사진';
COMMENT ON COLUMN STUDY.STUDY_RECRUIT IS '모집여부(Y/N)';

CREATE TABLE STUDY_MEMBER(
    MEMBER_NO NUMBER NOT NULL,
    STUDY_NO NUMBER NOT NULL,
    CONFIRM_DATE DATE DEFAULT NULL, -- NULL은 미승인, 승인시 날짜 삽입, 거부시 삭제
    CONSTRAINT SM_PK PRIMARY KEY(MEMBER_NO,STUDY_NO),
    CONSTRAINT SM_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT SM_SNO_FK FOREIGN KEY(STUDY_NO) REFERENCES STUDY(STUDY_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN STUDY_MEMBER.MEMBER_NO IS '가입멤버번호';
COMMENT ON COLUMN STUDY_MEMBER.STUDY_NO IS '가입스터디번호';
COMMENT ON COLUMN STUDY_MEMBER.CONFIRM_DATE IS '승인날짜';

CREATE TABLE TALKROOM(
    TALKROOM_NO NUMBER,
    MANAGER_NO NUMBER NOT NULL,
    STUDY_NO NUMBER,
    TALKROOM_TYPE NUMBER NOT NULL, -- 1: 멘토 톡방 / 2: 스터디 그룹 톡방
    CONSTRAINT TR_TNO_PK PRIMARY KEY (TALKROOM_NO),
    CONSTRAINT TR_SNO_FK FOREIGN KEY (STUDY_NO) REFERENCES STUDY(STUDY_NO) ON DELETE CASCADE,
    CONSTRAINT TR_MNO_FK FOREIGN KEY (MANAGER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN TALKROOM.TALKROOM_NO IS '톡방번호';
COMMENT ON COLUMN TALKROOM.MANAGER_NO IS '관리자번호';
COMMENT ON COLUMN TALKROOM.STUDY_NO IS '스터디번호(스터디톡방일시)';
COMMENT ON COLUMN TALKROOM.TALKROOM_TYPE IS '톡방유형(멘토1/스터디2)';

CREATE TABLE MEMBER_TALKROOM(
    MEMBER_NO NUMBER NOT NULL,
    TALKROOM_NO NUMBER NOT NULL,
    CONSTRAINT MTR_FK PRIMARY KEY(MEMBER_NO, TALKROOM_NO),
    CONSTRAINT MTR_MNO_FK FOREIGN KEY (MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT MTR_TNO_FK FOREIGN KEY (TALKROOM_NO) REFERENCES TALKROOM(TALKROOM_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN MEMBER_TALKROOM.MEMBER_NO IS '톡방회원번호';
COMMENT ON COLUMN MEMBER_TALKROOM.TALKROOM_NO IS '톡방번호';

CREATE TABLE MESSAGE(
    MESSAGE_NO NUMBER,
    TALKROOM_NO NUMBER NOT NULL,
    MEMBER_NO NUMBER,
    MESSAGE_CONTENT VARCHAR2(900),
    MESSAGE_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MSG_MNO_PK PRIMARY KEY (MESSAGE_NO),
    CONSTRAINT MSG_TNO_FK FOREIGN KEY (TALKROOM_NO) REFERENCES TALKROOM(TALKROOM_NO) ON DELETE CASCADE,
    CONSTRAINT MSG_MNO_FK FOREIGN KEY (MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE SET NULL
);

COMMENT ON COLUMN MESSAGE.MESSAGE_NO IS '메시지번호';
COMMENT ON COLUMN MESSAGE.TALKROOM_NO IS '톡방번호';
COMMENT ON COLUMN MESSAGE.MEMBER_NO IS '메시지보낸회원번호';
COMMENT ON COLUMN MESSAGE.MESSAGE_CONTENT IS '메시지내용';

CREATE TABLE MEMBER_LICENSE(
    LICENSE_NO NUMBER NOT NULL,
    MEMBER_NO NUMBER NOT NULL,
    CONFIRM_DATE DATE DEFAULT NULL, -- NULL은 미승인, 승인시 날짜 삽입, 거부시 삭제
    SYMBOL_LICENSE VARCHAR2(3) DEFAULT 'N' CHECK(SYMBOL_LICENSE IN('Y','N')),
    LICENSE_IMG VARCHAR2(300),
    CONSTRAINT ML_PK PRIMARY KEY(LICENSE_NO,MEMBER_NO),
    CONSTRAINT ML_LNO_FK FOREIGN KEY(LICENSE_NO) REFERENCES LICENSE(LICENSE_NO) ON DELETE CASCADE,
    CONSTRAINT ML_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN MEMBER_LICENSE.LICENSE_NO IS '보유자격증번호';
COMMENT ON COLUMN MEMBER_LICENSE.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN MEMBER_LICENSE.CONFIRM_DATE IS '승인날짜';
COMMENT ON COLUMN MEMBER_LICENSE.SYMBOL_LICENSE IS '대표자격증(Y/N)';
COMMENT ON COLUMN MEMBER_LICENSE.LICENSE_IMG IS '자격증인증이미지경로';

CREATE TABLE MEMBER_LOOK_LICENSE(
    MEMBER_NO NUMBER NOT NULL,
    LICENSE_NO NUMBER NOT NULL,
    CONSTRAINT MLL_PK PRIMARY KEY(MEMBER_NO, LICENSE_NO),
    CONSTRAINT MLL_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT MLL_LNO_FK FOREIGN KEY(LICENSE_NO) REFERENCES LICENSE(LICENSE_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN MEMBER_LOOK_LICENSE.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN MEMBER_LOOK_LICENSE.LICENSE_NO IS '관심자격증번호';

CREATE TABLE MEMBER_CALENDAR(
    CALENDAR_NO NUMBER,
    MEMBER_NO NUMBER NOT NULL,
    START_DATE DATE NOT NULL,
    END_DATE DATE NOT NULL, 
    CALENDAR_DETAIL VARCHAR2(300) NOT NULL,
    BACKGROUND_COLOR VARCHAR2(100) NOT NULL,
    TEXT_COLOR VARCHAR2(100) NOT NULL,
    CONSTRAINT MC_CNO_PK PRIMARY KEY(CALENDAR_NO),
    CONSTRAINT MC_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN MEMBER_CALENDAR.CALENDAR_NO IS '일정고유번호';
COMMENT ON COLUMN MEMBER_CALENDAR.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN MEMBER_CALENDAR.START_DATE IS '일정시작날짜';
COMMENT ON COLUMN MEMBER_CALENDAR.END_DATE IS '일정마감날짜';
COMMENT ON COLUMN MEMBER_CALENDAR.CALENDAR_DETAIL IS '일정내용';

CREATE TABLE MENTOR_LIKE_LOG(
    MEMBER_NO NUMBER NOT NULL,
    MENTOR_NO NUMBER NOT NULL,
    CONSTRAINT MTLL_PK PRIMARY KEY(MEMBER_NO, MENTOR_NO),
    CONSTRAINT MTLL_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT MTLL_MTNO_FK FOREIGN KEY(MENTOR_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN MENTOR_LIKE_LOG.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN MENTOR_LIKE_LOG.MENTOR_NO IS '멘토번호';

CREATE TABLE ALERT(
    ALERT_NO NUMBER,
    MEMBER_NO NUMBER NOT NULL,
    ALERT_DETAIL VARCHAR2(300) NOT NULL,
    CONSTRAINT AL_ANO_PK PRIMARY KEY(ALERT_NO),
    CONSTRAINT AL_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN ALERT.ALERT_NO IS '알림고유번호';
COMMENT ON COLUMN ALERT.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN ALERT.ALERT_DETAIL IS '알림내용';

CREATE TABLE COMPILER_LOG(
    COMPILE_NO NUMBER,
    MEMBER_NO NUMBER NOT NULL,
    CODE VARCHAR(2000) NOT NULL,
    EXEC_RESULT VARCHAR(1000),
    EXEC_TIME VARCHAR(30),
    COMPILE_DATE DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT CL_CNO_PK PRIMARY KEY(COMPILE_NO),
    CONSTRAINT CL_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN COMPILER_LOG.COMPILE_NO IS '로그번호';
COMMENT ON COLUMN COMPILER_LOG.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN COMPILER_LOG.CODE IS '코드내용';
COMMENT ON COLUMN COMPILER_LOG.EXEC_RESULT IS '실행결과';
COMMENT ON COLUMN COMPILER_LOG.EXEC_TIME IS '코드수행시간';
COMMENT ON COLUMN COMPILER_LOG.COMPILE_DATE IS '작성시간';

CREATE TABLE DATA_BOARD(
    DATA_BOARD_NO NUMBER,
    MEMBER_NO NUMBER NOT NULL,
    DATA_BOARD_TITLE VARCHAR2(300) NOT NULL,
    DATA_BOARD_CONTENT VARCHAR2(3000),
    BOARD_DATE DATE DEFAULT SYSDATE NOT NULL,
    VIEW_COUNT NUMBER DEFAULT 0,
    CONSTRAINT DB_BNO_PK PRIMARY KEY(DATA_BOARD_NO),
    CONSTRAINT DB_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN DATA_BOARD.DATA_BOARD_NO IS '자료게시글번호';
COMMENT ON COLUMN DATA_BOARD.MEMBER_NO IS '멤버번호';
COMMENT ON COLUMN DATA_BOARD.DATA_BOARD_TITLE IS '게시글제목';
COMMENT ON COLUMN DATA_BOARD.DATA_BOARD_CONTENT IS '게시글내용';
COMMENT ON COLUMN DATA_BOARD.BOARD_DATE IS '작성시간';
COMMENT ON COLUMN DATA_BOARD.VIEW_COUNT IS '조회수';

CREATE TABLE DATA_BOARD_ATTACH(
    DATA_BOARD_ATT_NO NUMBER,
    DATA_BOARD_NO NUMBER,
    DATA_BOARD_ATT_PATH VARCHAR2(300),
    CONSTRAINT DBA_DBANO_PK PRIMARY KEY(DATA_BOARD_ATT_NO),
    CONSTRAINT DBA_DBNO_FK FOREIGN KEY(DATA_BOARD_NO) REFERENCES DATA_BOARD(DATA_BOARD_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN DATA_BOARD_ATTACH.DATA_BOARD_ATT_NO IS '자료 번호';
COMMENT ON COLUMN DATA_BOARD_ATTACH.DATA_BOARD_NO IS '자료 게시글 번호';
COMMENT ON COLUMN DATA_BOARD_ATTACH.DATA_BOARD_ATT_PATH IS '자료 경로';

CREATE TABLE BOARD(
    BOARD_NO NUMBER,
    TAB_NO NUMBER NOT NULL,
    LICENSE_NO NUMBER NOT NULL,
    MEMBER_NO NUMBER NOT NULL,
    BOARD_TITLE VARCHAR2(300) NOT NULL,
    BOARD_CONTENT VARCHAR2(3000) NOT NULL,
    BOARD_DATE DATE DEFAULT SYSDATE NOT NULL,
    LIKE_COUNT NUMBER DEFAULT 0,
    HATE_COUNT NUMBER DEFAULT 0,
    STATUS VARCHAR2(3) DEFAULT 'Y' CHECK( STATUS IN ('Y','N') ), -- 게시글 정상/삭제/임시
    VIEW_COUNT NUMBER DEFAULT 0,
    CONSTRAINT B_BNO_PK PRIMARY KEY(BOARD_NO),
    CONSTRAINT B_TNO_FK FOREIGN KEY(TAB_NO) REFERENCES BOARD_TAB(TAB_NO) ON DELETE CASCADE,
    CONSTRAINT B_LNO_FK FOREIGN KEY(LICENSE_NO) REFERENCES LICENSE(LICENSE_NO) ON DELETE CASCADE,
    CONSTRAINT B_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN BOARD.BOARD_NO IS '게시글번호';
COMMENT ON COLUMN BOARD.TAB_NO IS '탭번호';
COMMENT ON COLUMN BOARD.LICENSE_NO IS '자격증게시판번호';
COMMENT ON COLUMN BOARD.MEMBER_NO IS '작성자번호';
COMMENT ON COLUMN BOARD.BOARD_TITLE IS '글제목';
COMMENT ON COLUMN BOARD.BOARD_CONTENT IS '글내용';
COMMENT ON COLUMN BOARD.BOARD_DATE IS '글쓴날짜';
COMMENT ON COLUMN BOARD.LIKE_COUNT IS '좋아요수';
COMMENT ON COLUMN BOARD.HATE_COUNT IS '싫어요수';
COMMENT ON COLUMN BOARD.STATUS IS '게시글상태(Y(정상)/N(삭제)/T(임시))';
COMMENT ON COLUMN BOARD.VIEW_COUNT IS '조회수';

CREATE TABLE REPLY(
    REPLY_NO NUMBER,
    BOARD_NO NUMBER NOT NULL,
    REPLY_PNO NUMBER,
    MEMBER_NO NUMBER NOT NULL,
    REPLY_CONTENT VARCHAR2(300) NOT NULL,
    STATUS VARCHAR2(3) DEFAULT 'Y' CHECK( STATUS IN ('Y','N')),
    REPLY_GROUP NUMBER DEFAULT 0,
    REPLY_DEPTH NUMBER DEFAULT 0,
    REPLY_ORDER NUMBER DEFAULT 0,
    CHILD_COUNT NUMBER DEFAULT 0,
    CONSTRAINT RP_RNO_PK PRIMARY KEY(REPLY_NO),
    CONSTRAINT RP_BNO_FK FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO) ON DELETE CASCADE,
    CONSTRAINT RP_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT RP_RNO_FK FOREIGN KEY(REPLY_PNO) REFERENCES REPLY(REPLY_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN REPLY.REPLY_NO IS '댓글번호';
COMMENT ON COLUMN REPLY.BOARD_NO IS '게시글번호';
COMMENT ON COLUMN REPLY.REPLY_PNO IS '부모댓글번호';
COMMENT ON COLUMN REPLY.MEMBER_NO IS '작성자번호';
COMMENT ON COLUMN REPLY.REPLY_CONTENT IS '댓글내용';
COMMENT ON COLUMN REPLY.STATUS IS '삭제여부(Y/N)';
COMMENT ON COLUMN REPLY.REPLY_GROUP IS '댓글그룹';
COMMENT ON COLUMN REPLY.REPLY_DEPTH IS '대댓글 가로깊이';
COMMENT ON COLUMN REPLY.REPLY_ORDER IS '대댓글 순서(세로)';
COMMENT ON COLUMN REPLY.CHILD_COUNT IS '달린 대댓글 수';

CREATE TABLE BOARD_LIKE_LOG(
    BOARD_NO NUMBER NOT NULL,
    MEMBER_NO NUMBER NOT NULL,
    CONSTRAINT BLLOG_PK PRIMARY KEY(BOARD_NO, MEMBER_NO),
    CONSTRAINT BLLOG_BNO_FK FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO) ON DELETE CASCADE,
    CONSTRAINT BLLOG_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN BOARD_LIKE_LOG.BOARD_NO IS '좋아요 누른 게시글번호';
COMMENT ON COLUMN BOARD_LIKE_LOG.MEMBER_NO IS '좋아요 누른 멤버번호';

CREATE TABLE BOARD_HATE_LOG(
    BOARD_NO NUMBER NOT NULL,
    MEMBER_NO NUMBER NOT NULL,
    CONSTRAINT BHLOG_PK PRIMARY KEY(BOARD_NO, MEMBER_NO),
    CONSTRAINT BHLOG_BNO_FK FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO) ON DELETE CASCADE,
    CONSTRAINT BHLOG_MNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN BOARD_HATE_LOG.BOARD_NO IS '싫어요 누른 게시글번호';
COMMENT ON COLUMN BOARD_HATE_LOG.MEMBER_NO IS '싫어요 누른 멤버번호';

CREATE TABLE STUDY_BOARD(
    STUDY_BOARD_NO NUMBER,
    STUDY_NO NUMBER NOT NULL,
    STUDY_BOARD_TITLE VARCHAR2(300) NOT NULL,
    STUDY_BOARD_CONTENT VARCHAR2(3000) NOT NULL,
    VIEW_COUNT NUMBER DEFAULT 0,
    STUDY_BOARD_DATE DATE DEFAULT SYSDATE NOT NULL,
    STATUS VARCHAR(3) DEFAULT 'Y' CHECK(STATUS IN ('Y','N')),
    CONSTRAINT SB_SBNO_PK PRIMARY KEY(STUDY_BOARD_NO),
    CONSTRAINT SB_SNO_FK FOREIGN KEY(STUDY_NO) REFERENCES STUDY(STUDY_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN STUDY_BOARD.STUDY_BOARD_NO IS '모집 게시글 번호';
COMMENT ON COLUMN STUDY_BOARD.STUDY_NO IS '스터디그룹번호';
COMMENT ON COLUMN STUDY_BOARD.STUDY_BOARD_TITLE IS '모집글 제목';
COMMENT ON COLUMN STUDY_BOARD.STUDY_BOARD_CONTENT IS '모집글 내용';
COMMENT ON COLUMN STUDY_BOARD.VIEW_COUNT IS '조회수';
COMMENT ON COLUMN STUDY_BOARD.STUDY_BOARD_DATE IS '작성일';
COMMENT ON COLUMN STUDY_BOARD.STATUS IS '게시글상태(Y(정상)/N(삭제))';

CREATE TABLE BOARD_IMG(
    IMG_NO NUMBER,
    BOARD_NO NUMBER,
    STUDY_BOARD_NO NUMBER,
    IMG_PATH VARCHAR2(300) NOT NULL,
    CONSTRAINT BIMG_INO_PK PRIMARY KEY(IMG_NO),
    CONSTRAINT BIMG_BNO_FK FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO) ON DELETE CASCADE,
    CONSTRAINT BIMG_SBNO_FK FOREIGN KEY(STUDY_BOARD_NO) REFERENCES STUDY_BOARD(STUDY_BOARD_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN BOARD_IMG.IMG_NO IS '이미지번호';
COMMENT ON COLUMN BOARD_IMG.BOARD_NO IS '게시글번호';
COMMENT ON COLUMN BOARD_IMG.STUDY_BOARD_NO IS '스터디모집글 번호';
COMMENT ON COLUMN BOARD_IMG.IMG_PATH IS '이미지경로';

CREATE TABLE REPORT_TYPE(
    REPORT_TYPE_NO NUMBER,
    REPORT_TYPE_DETAIL VARCHAR2(120) NOT NULL,
    CONSTRAINT RT_RTNO_PK PRIMARY KEY(REPORT_TYPE_NO)
);

COMMENT ON COLUMN REPORT_TYPE.REPORT_TYPE_NO IS '신고유형번호';
COMMENT ON COLUMN REPORT_TYPE.REPORT_TYPE_DETAIL IS '신고유형내용';

CREATE TABLE REPORT(
    REPORT_NO NUMBER,
    ACCUSER_NO NUMBER NOT NULL,
    ACCUSED_NO NUMBER NOT NULL,
    BOARD_NO NUMBER,
    REPLY_NO NUMBER,
    MESSAGE_NO NUMBER,
    STUDY_BOARD_NO NUMBER,
    REPORT_TYPE_NO NUMBER,
    REPORT_DETAIL VARCHAR2(300),
    CONSTRAINT RPT_RNO_PK PRIMARY KEY(REPORT_NO),
    CONSTRAINT RPT_ACRNO_FK FOREIGN KEY(ACCUSER_NO) REFERENCES MEMBER(MEMBER_NO),
    CONSTRAINT RPT_ACDNO_FK FOREIGN KEY(ACCUSED_NO) REFERENCES MEMBER(MEMBER_NO),
    CONSTRAINT RPT_BNO_FK FOREIGN KEY(BOARD_NO) REFERENCES BOARD(BOARD_NO),
    CONSTRAINT RPT_RNO_FK FOREIGN KEY(REPLY_NO) REFERENCES REPLY(REPLY_NO),
    CONSTRAINT RPT_MNO_FK FOREIGN KEY(MESSAGE_NO) REFERENCES MESSAGE(MESSAGE_NO),
    CONSTRAINT RPT_SBNO_FK FOREIGN KEY(STUDY_BOARD_NO) REFERENCES STUDY_BOARD(STUDY_BOARD_NO),
    CONSTRAINT RPT_RTNO_FK FOREIGN KEY(REPORT_TYPE_NO) REFERENCES REPORT_TYPE(REPORT_TYPE_NO)
);

COMMENT ON COLUMN REPORT.REPORT_NO IS '신고번호';
COMMENT ON COLUMN REPORT.ACCUSER_NO IS '신고인번호';
COMMENT ON COLUMN REPORT.ACCUSED_NO IS '피신고인번호';
COMMENT ON COLUMN REPORT.BOARD_NO IS '커뮤니티게시판번호';
COMMENT ON COLUMN REPORT.REPLY_NO IS '댓글번호';
COMMENT ON COLUMN REPORT.MESSAGE_NO IS '메시지번호';
COMMENT ON COLUMN REPORT.STUDY_BOARD_NO IS '스터디모집게시글번호';
COMMENT ON COLUMN REPORT.REPORT_TYPE_NO IS '신고유형번호';
COMMENT ON COLUMN REPORT.REPORT_DETAIL IS '신고세부내용';

CREATE TABLE APPLY_LOG(
    APPLY_NO NUMBER,
    APPLICANT_NO NUMBER NOT NULL,
    RECIPIENT_NO NUMBER NOT NULL,
    STUDY_NO NUMBER,
    APPLY_KIND NUMBER,
    APPLY_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT APL_NO_PK PRIMARY KEY(APPLY_NO),
    CONSTRAINT APL_ANO_FK FOREIGN KEY(APPLICANT_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT APL_RNO_FK FOREIGN KEY(RECIPIENT_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE,
    CONSTRAINT APL_SNO_FK FOREIGN KEY(STUDY_NO) REFERENCES STUDY(STUDY_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN APPLY_LOG.APPLY_NO IS '신청번호';
COMMENT ON COLUMN APPLY_LOG.APPLICANT_NO IS '신청인번호';
COMMENT ON COLUMN APPLY_LOG.RECIPIENT_NO IS '수취인번호';
COMMENT ON COLUMN APPLY_LOG.STUDY_NO IS '스터디번호';
COMMENT ON COLUMN APPLY_LOG.APPLY_KIND IS '신청유형(1:멘토/2:스터디)';
COMMENT ON COLUMN APPLY_LOG.APPLY_DATE IS '신청날짜';

CREATE TABLE CHATBOT_LOG(
    LOG_NO NUMBER,
    IP_ADDR VARCHAR(23) NOT NULL,
    CHAT_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT CBLOG_NO_PK PRIMARY KEY(CHAT_DATE, LOG_NO)
);

COMMENT ON COLUMN CHATBOT_LOG.LOG_NO IS '로그번호';
COMMENT ON COLUMN CHATBOT_LOG.IP_ADDR IS 'IP주소';
COMMENT ON COLUMN CHATBOT_LOG.CHAT_DATE IS '채팅날짜';

--create table calendar(
--	CALENDAR_NO number,
--	TITLE varchar2(50) NOT NULL,
--	CONTENT varchar2(1000),
--	START_DAY date NOT NULL,
--	END_DAY date NOT NULL,
--    ALL_DAY NUMBER,
--    LICENSE_NO NUMBER,
--	TEXT_COLOR varchar2(50) default 'black',
--	BACKGROUND_COLOR varchar2(50) default 'white',
--	BORDER_COLOR varchar2(50) default 'white',
--    CONSTRAINT CALENDAR_NO_PK PRIMARY KEY(CALENDAR_NO),
--    CONSTRAINT CALENDAR_LNO_FK FOREIGN KEY(LICENSE_NO) REFERENCES LICENSE(LICENSE_NO)
--);
--
--COMMENT ON COLUMN calendar.id IS '일정번호';
--COMMENT ON COLUMN calendar.title IS '일정제목';
--COMMENT ON COLUMN calendar.content IS '일정내용';
--COMMENT ON COLUMN calendar.START_DAY IS '일정 시작일';
--COMMENT ON COLUMN calendar.END_DAY IS '일정 마지막일';
--COMMENT ON COLUMN calendar.ALL_DAY IS '하루종일 일정 여부(0:x/1:o)';
--COMMENT ON COLUMN calendar.LICENSE_NO IS '자격증 번호';
--COMMENT ON COLUMN calendar.TEXT_COLOR IS '해당일 캘린더 글자색';
--COMMENT ON COLUMN calendar.BACKGROUND_COLOR IS '해당일 캘린더 배경색';
--COMMENT ON COLUMN calendar.BORDER_COLOR IS '해당일 캘린더 테두리색';

-- 시퀀스 생성
CREATE SEQUENCE BOARD_TAB_SEQ;
CREATE SEQUENCE BOARD_SEQ START WITH 316;
CREATE SEQUENCE BOARD_IMG_SEQ;
CREATE SEQUENCE REPLY_SEQ START WITH 301;
CREATE SEQUENCE LICENSE_SEQ;
CREATE SEQUENCE MEMBER_SEQ START WITH 40;
CREATE SEQUENCE STUDY_SEQ START WITH 13;
CREATE SEQUENCE STUDY_BOARD_SEQ START WITH 68;
CREATE SEQUENCE REPORT_SEQ;
CREATE SEQUENCE REPORT_TYPE_SEQ;
CREATE SEQUENCE COMPILE_SEQ;
CREATE SEQUENCE MENTOR_LIKE_LOG_SEQ;
CREATE SEQUENCE ALERT_SEQ;
CREATE SEQUENCE TALKROOM_SEQ START WITH 2;
CREATE SEQUENCE MESSAGE_SEQ;
CREATE SEQUENCE DATA_BOARD_ATT_SEQ;
CREATE SEQUENCE DATA_BOARD_SEQ;
CREATE SEQUENCE APPLY_LOG_SEQ;
CREATE SEQUENCE CHATBOT_LOG_SEQ;
CREATE SEQUENCE MEMBER_CALENDAR_SEQ START WITH 4;

-- 기본값 세팅
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '공지');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '자유');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '질문(자유)');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '질문(코딩)');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '후기');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '문제집/강의 추천');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '문제집 거래');

INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보처리기사','<실기시험 출제 경향>


정보시스템 등의 개발 요구 사항을 이해하여 각 업무에 맞는 소프트웨어의 기능에 관한 설계, 구현 및 테스트를 수행에 필요한 

1. 현행 시스템 분석 및 요구사항 확인(소프트웨어 공학 기술의 요구사항 분석 기법 활용)

2. 데이터 입출력 구현(논리, 물리데이터베이스 설계, 조작 프로시저 등)

3. 통합 구현(소프트웨어와 연계 대상 모듈간의 특성 및 연계 모듈 구현 등)

4. 서버프로그램 구현(소프트웨어 개발 환경 구축, 형상 관리, 공통 모듈, 테스트 수행 등)

5. 인터페이스 구현(소프트웨어 공학 지식, 소프트웨어 인터페이스 설계, 기능 구현, 구현검증 등)

6. 화면설계(UI 요구사항 및 설계, 표준 프로토 타입 제작 등)

7. 애플리케이션 테스트 (테스트 케이스 설계, 통합 테스트, 성능 개선 등)

8. SQL 응용(SQL 작성 등)

9. 소프트웨어 개발 보안 구축(SW 개발 보안 설계, SW개발 보안 구현 등)

10. 프로그래밍 언어활용(기본 문법 등)

11. 응용 SW기초 기술 활용(운영체제, 데이터베이스 활용, 네트워크 활용, 개발환경 구축 등)

12. 제품 소프트웨어 패키징(제품 소프트웨어 패키징, 제품소프트웨어 매뉴얼 작성 , 버전 관리등 )

<세부 평가 내역>

- 필기시험의 내용은 고객지원 > 자료실의 출제기준을 참고 바랍니다.

- 실기시험은 필답형을 시행되며 고객지원> 자료실의 출제기준을 참고 바랍니다.

  출제기준 참조(www.q-net.or.kr)');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'네트워크관리사','네트워크관리사란 서버를 구축하고 보안 설정, 시스템 최적화 등 네트워크구축 및 이를 효과적으로 관리할 수 있는 인터넷 관련 기술력에 대한 자격이다.');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보보안기사','정보보안기사(Engineer information security)는 과학기술정보통신부에서 주관하고 한국방송통신전파진흥원[1]에서 시행하는 국가자격 시험 및 그 자격증을 의미한다. 기존 한국인터넷진흥원 국가 공인 민간 자격증인 정보보호전문가(SIS) 자격증을 국가 기술 자격으로 업그레이드시킨 자격이다.[2] 정보보호전문가는 2001년 신설되고 2005년 국가 공인을 받았으며, 2013년부터 정보보안(산업)기사의 신설이 결정되면서 2012년을 끝으로 폐지되었다. 2013년부터 시작하여 연 2회씩 시험을 보다가, 2022년부터는 연 3회씩 응시 가능하다. 2022년 2회부터 필기에서 PBT와 CBT를 동시에 시행하다가, 2024년부터 100% CBT로 전환할 예정이다.
');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'빅데이터분석기사','2019년 창설된 대한민국의 기사등급 국가기술자격.
주무부처는 과학기술정보통신부와 통계청이며 검정시행기관은 한국데이터산업진흥원(K-DATA)이다.

4차 산업혁명 시대를 맞아 빅데이터분석 전문인력 공급에 주력하기 위해 개발되었다. 빅데이터와 관련하여 관심과 수요가 증가한데 반해 필요한 역량, 기술, 지식 등의 기준 없이 수많은 민간 자격증이 난립하고 있는 상황을 해결하기 위해 신설되었다.

한국데이터산업진흥원에서 시행하는 ADP, ADsP와 빅데이터분석기사는 모두 시험 내용이 유사하지만 각 난이도에 차이가 있다. ADsP < 빅데이터분석기사 < ADP 순으로 실기시험이 없는 ADsP가 가장 쉽고, ADP는 빅데이터분석기사보다 훨씬 어려운 실기시험이 출제된다. 빅데이터분석기사를 취득했다면 ADsP는 중복이라 필요없지만 ADP 응시자격을 갖추기 위해 응시할 수도 있다[1].

빅데이터분석기사 시험은 2021년 4월 17일 첫 시험을 치렀고, 1년에 2회 실시한다. 자격증에는 과학기술정보통신부장관과 통계청장이 적혀 나온다. 자격증은 상장형과 카드형 실물자격증으로 발급된다. 카드형은 2023년부터 발급이 가능해졌으며 발급비용으로 약 6천원 정도를 받는다. 발급까지는 약 2주 정도 소요된다.');

INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'홍보/도배');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'음란물');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'불법');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'욕설');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'혐오발언');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'사칭');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'괴롭힘 및 따돌림');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'기타');


COMMIT;