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
DROP TABLE NOTICE_BOARD;
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
DROP SEQUENCE MEMBER_CALENDAR_SEQ;
DROP SEQUENCE NOTICE_BOARD_SEQ;

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
    LICENSE_DOC_EXAM VARCHAR2(150),
    LICENSE_PRAC_EXAM VARCHAR2(150),
    LICENSE_EXAM_SCOPE VARCHAR2(1000),
    CONSTRAINT L_LNO_PK PRIMARY KEY(LICENSE_NO)
);

COMMENT ON COLUMN LICENSE.LICENSE_NO IS '자격증번호';
COMMENT ON COLUMN LICENSE.LICENSE_NAME IS '자격증이름';
COMMENT ON COLUMN LICENSE.LICENSE_DESC IS '자격증설명';
COMMENT ON COLUMN LICENSE.LICENSE_DOC_EXAM IS '필기수험료';
COMMENT ON COLUMN LICENSE.LICENSE_PRAC_EXAM IS '실기수험료';
COMMENT ON COLUMN LICENSE.LICENSE_EXAM_SCOPE IS '출제범위';

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
    SOCIAL VARCHAR2(3),
    SOCIAL_ID VARCHAR2(60) UNIQUE,
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
    LAST_UPDATE DATE DEFAULT SYSDATE,
    CONSTRAINT TR_TNO_PK PRIMARY KEY (TALKROOM_NO),
    CONSTRAINT TR_SNO_FK FOREIGN KEY (STUDY_NO) REFERENCES STUDY(STUDY_NO) ON DELETE CASCADE,
    CONSTRAINT TR_MNNO_FK FOREIGN KEY (MANAGER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN TALKROOM.TALKROOM_NO IS '톡방번호';
COMMENT ON COLUMN TALKROOM.MANAGER_NO IS '관리자번호';
COMMENT ON COLUMN TALKROOM.STUDY_NO IS '스터디번호(스터디톡방일시)';
COMMENT ON COLUMN TALKROOM.TALKROOM_TYPE IS '톡방유형(멘토1/스터디2)';
COMMENT ON COLUMN TALKROOM.LAST_UPDATE IS '마지막톡시간(정렬용)';

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

CREATE TABLE NOTICE_BOARD(
    NOTICE_BOARD_NO NUMBER,
    MEMBER_NO NUMBER NOT NULL,
    NOTICE_BOARD_TITLE VARCHAR2(300) NOT NULL,
    NOTICE_BOARD_CONTENT VARCHAR2(3000) NOT NULL,
    VIEW_COUNT NUMBER DEFAULT 0,
    NOTICE_BOARD_DATE DATE DEFAULT SYSDATE NOT NULL,
    STATUS VARCHAR(3) DEFAULT 'Y' CHECK(STATUS IN ('Y','N')),
    CONSTRAINT NB_SBNO_PK PRIMARY KEY(NOTICE_BOARD_NO),
    CONSTRAINT NB_SNO_FK FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO) ON DELETE CASCADE
);

COMMENT ON COLUMN NOTICE_BOARD.NOTICE_BOARD_NO IS '공지 게시글 번호';
COMMENT ON COLUMN NOTICE_BOARD.MEMBER_NO IS '관리자번호';
COMMENT ON COLUMN NOTICE_BOARD.NOTICE_BOARD_TITLE IS '공지 제목';
COMMENT ON COLUMN NOTICE_BOARD.NOTICE_BOARD_CONTENT IS '공지 내용';
COMMENT ON COLUMN NOTICE_BOARD.VIEW_COUNT IS '조회수';
COMMENT ON COLUMN NOTICE_BOARD.NOTICE_BOARD_DATE IS '작성일';
COMMENT ON COLUMN NOTICE_BOARD.STATUS IS '게시글상태(Y(정상)/N(삭제))';

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
    APPLY_DATE DATE,
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
COMMENT ON COLUMN APPLY_LOG.APPLY_DATE IS '신청승인날짜';

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
CREATE SEQUENCE REPORT_SEQ START WITH 101;
CREATE SEQUENCE REPORT_TYPE_SEQ;
CREATE SEQUENCE COMPILE_SEQ;
CREATE SEQUENCE MENTOR_LIKE_LOG_SEQ;
CREATE SEQUENCE ALERT_SEQ;
CREATE SEQUENCE TALKROOM_SEQ START WITH 2;
CREATE SEQUENCE MESSAGE_SEQ;
CREATE SEQUENCE DATA_BOARD_ATT_SEQ;
CREATE SEQUENCE DATA_BOARD_SEQ START WITH 1;
CREATE SEQUENCE APPLY_LOG_SEQ;
CREATE SEQUENCE CHATBOT_LOG_SEQ;
CREATE SEQUENCE MEMBER_CALENDAR_SEQ START WITH 4;
CREATE SEQUENCE NOTICE_BOARD_SEQ;

-- 기본값 세팅
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '공지');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '자유');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '질문(자유)');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '질문(코딩)');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '후기');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '문제집/강의 추천');
INSERT INTO BOARD_TAB VALUES(BOARD_TAB_SEQ.NEXTVAL, '문제집 거래');

INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보처리기사','소프트웨어 개발 관련 자격증으로, 정보시스템의 생명주기 전반에 걸친 프로젝트 업무를 수행하는 직무로서 계획수립, 분석, 설계, 구현, 시험, 운영, 유지보수 등의 업무를 수행할 수 있는 능력을 검증하는 시험이다.',
'19,400원','22,600원', CHR(10) || '1.소프트웨어설계' || CHR(10) || '2.소프트웨어개발' || CHR(10) || '3.데이터베이스구축' || CHR(10) || '4.프로그래밍언어활용' || CHR(10) || '5.정보시스템구축관리');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'네트워크관리사','네트워크관리사란 서버를 구축하고 보안 설정, 시스템 최적화 등 네트워크구축 및 이를 효과적으로 관리할 수 있는 인터넷 관련 기술력에 대한 자격이다.',
'43,000원','78,000원', CHR(10) || '1.TCP/IP' || CHR(10) || '2.네트워크일반' || CHR(10) || '3.NOS' || CHR(10) || '4.네트워크 운용기기' );
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보보안기사','정보보안기사(Engineer information security)는 과학기술정보통신부에서 주관하고 한국방송통신전파진흥원에서 시행하는 국가자격 시험 및 그 자격증을 의미한다.기존 한국인터넷진흥원 국가 공인 민간 자격증인 정보보호전문가(SIS) 자격증을 국가 기술 자격으로 업그레이드시킨 자격이다.',
'18,800원','21,900원', CHR(10) || '1.시스템보안' || CHR(10) || '2.네트워크보안' || CHR(10) || '3.어플리케이션보안' || CHR(10) || '4.정보보안일반' || CHR(10) || '5.정보보안관리 및 법규');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'빅데이터분석기사','2019년 창설된 대한민국의 기사등급 국가기술자격. 주무부처는 과학기술정보통신부와 통계청이며 검정시행기관은 한국데이터산업진흥원(K-DATA)이다.4차 산업혁명 시대를 맞아 빅데이터분석 전문인력 공급에 주력하기 위해 개발되었다. 빅데이터와 관련하여 관심과 수요가 증가한데 반해 필요한 역량, 기술, 지식 등의 기준 없이 수많은 민간 자격증이 난립하고 있는 상황을 해결하기 위해 신설되었다.',
'17,800원','40,800원', CHR(10) || '1.빅데이터 분석기획' || CHR(10) || '2.빅데이터 탐색' || CHR(10) || '3.빅데이터 모델링' || CHR(10) || '4.빅데이터 결과 해석');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보통신기사','과학기술정보통신부에서 주관하는 자격. 1974년 유선설비기사1급으로 신설, 1991년에 정보통신설비기사1급이 등장하였으며 1998년 이를 통합하여 정보통신기사로 변경되었다.',
'18,800원','21,900원', CHR(10) || '1. 정보전송일반' || CHR(10) || '2. 정보통신기기' || CHR(10) || '3. 정보통신네트워크' || CHR(10) || '4. 정보시스템운용' || CHR(10) || '5. 컴퓨터 일반 및 정보설비 기준');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보관리기술사','정보관리기술사(Professional Engineer Information Management)는 정보관리에 관련된 실무경험, 일반지식, 전문지식 및 응용능력과 기술사로서의 지도감리능력, 자질 및 품위를 측정하여 수여되는 기술사 자격증으로 국가기술자격의 일종이다. 정보처리기술사(수학응용)와 정보처리기술사(정보처리)가 1991년에 통합되어 정보관리기술사로 바뀐 것이다.',
'67,800원','	87,100원', CHR(10) || '1.영역1' || CHR(10) || '2.영역2' || CHR(10) || '3.영역3' || CHR(10) || '4.영역4');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'컴퓨터시스템응용기술사','컴퓨터시스템응용기술사(Professional Engineer Computer System Application)는 과학기술정보통신부에서 주관하고 한국산업인력공단에서 시행하는 국가기술자격으로 기술사에 해당한다. 2010년에 정보기술 분야의 전자계산조직응용기술사와 전자 분야의 전자계산기기술사가 통합되어 현재의 명칭이 되었다.',
'67,800원','87,100원', CHR(10) || '1.영역1' || CHR(10) || '2.영역2' || CHR(10) || '3.영역3' || CHR(10) || '4.영역4');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'정보통신기술사','정보통신분야 최고 권위의 자격증이다.정보통신기술사는 정보통신기술(ICT)에 관한 고도의 전문지식과 실무경험을 바탕으로 계획?연구?설계?분석?조사?시험?시공?감리?평가?진단?시험운전?사업관리?기술판단(기술감정을 포함)?기술중재 또는 이에 관한 기술자문과 기술지도 업무를 수행하는 직무를 수행하는데 필요한 기술요건을 갖추었음을 입증한다.',
'65,800원','82,200원','무선, 유선통신망의 설계, 시공, 보전 및 음성, 데이터, 방송에 관계되는 통신방식, 프로토콜, 기기와 설비, 기술기준에 관계되는 사항');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'임베디드기사','대한민국의 컴퓨터 관련 자격증. 전자 분야 기사급 국가기술자격이다. 임베디드 시스템의 하드웨어를 분석하여 하드웨어에 대한 초기화 및 테스트 수행, 운영체제(OS) 부팅을 위한 부트로더를 포함하는 펌웨어와 임베디드 시스템의 OS 관련한 플랫폼 소프트웨어 및 응용 소프트웨어를 설계, 구현하는 능력 평가',
'19,400원','22,600원', CHR(10) || '1.임베디드하드웨어' || CHR(10) || '2.임베디드펌웨어' || CHR(10) || '3.임베디드플랫폼' || CHR(10) || '4.임베디드소프트웨어');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'로봇소프트웨어개발기사','로봇의 제어부분을 설계 및 개발할 수 있는 능력을 검증하는 자격증이다. 기계공학, 컴퓨터공학 관련 학과 졸업(예정)자가 응시할 수 있다.',
'19,400원','30,300원', CHR(10) || '1.로봇운영소프트웨어' || CHR(10) || '2.로봇소프트웨어구조설계' || CHR(10) || '3.모션소프트웨어' || CHR(10) || '4.지능소프트웨어');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'전자계산기기사','전자계산기기사는 컴퓨터의 중앙처리장치, 주변장치, 입력장치, 출력장치 및 보조기억장치들의 성능을 향상시키기 위하여 컴퓨터 시스템을 설계하고 설치 및 운용하는 업무 수행을 위한 국가기술자격 중 기사 자격이다.',
'19,400원','22,600원', CHR(10) || '1.시스템프로그래밍' || CHR(10) || '2.전자계산기구조' || CHR(10) || '3.마이크로전자계산기' || CHR(10) || '4.논리회로' || CHR(10) || '5.데이타통신');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'전자계산기조직응용기사','전자계산기조직응용기사는 컴퓨터 시스템의 하드웨어 구성과 시스템 운용을 위한 응용소프트웨어의 설계 및 구성에 따른 효율적인 전산 시스템을 설치, 운영하고 전자계산기 시스템을 유지, 보수하는 능력을 평가하여 부여하는 국가기술자격 중 기사 자격이다.2026년에 전자계산기기사를 흡수합병하고, 명칭도 컴퓨터시스템기사로 바뀐다.',
'19,400원','22,600원', CHR(10) || '1.전자계산기프로그래밍' || CHR(10) || '2.자료구조및데이타통신' || CHR(10) || '3.전자계산기구조' || CHR(10) || '4.운영체제' || CHR(10) || '5.마이크로전자계산기');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'SQLD','Kdata(한국데이터산업진흥원)에서 주관하는 시험. SQLD는 SQL(Structured Query Language) + D(Developer)의 줄인 말로, SQL 개발자를 의미한다.2013년부터 민간자격증에서 국가 공인 민간자격증으로 승격되었다',
'50,000원','실기없음',' CHR(10) || 1.데이터 모델링의 이해' || CHR(10) || '2.SQL 기본 및 활용');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'SQLP','SQL(Structured Query Language) + P(Professional)의 줄인 말로, SQL 전문가를 의미한다. 공인자격 제2013-02호에 해당하는 데이터베이스 SQL 국가공인 자격증이다. 하위 자격증으로 SQLD가 있다.',
'100,000원','실기없음',' CHR(10) || 1.데이터 모델링의 이해' || CHR(10) || '2.SQL 기본 및 활용' || CHR(10) || 'SQL 고급활용 및 튜닝');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'데이터분석 전문가','데이터분석 전문가 자격검정 시험. 빅데이터 시대가 도래하고 데이터 분석가의 필요성이 증가함에 따라 데이터 분석 전문가 자격에 대한 기업의 수요를 반영하여 2014년부터 실시한 시험으로 과학기술정보통신부가 주무부처이고 한국데이터산업진흥원이 시행한다.공식 명칭인 국가공인 데이터분석 전문가를 영어로 쓴 Advanced Data Analytics Professional를 줄여서 ADP라고 부른다.',
'80,000원','70,000원', CHR(10) || '1.데이터 이해' || CHR(10) || '2.데이터 처리 기술 이해' || CHR(10) || '3.데이터분석 기획' || CHR(10) || '4.데이터분석' || CHR(10) || '5.데이터 시각화');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '컴퓨터응용밀링기능사', '공작기계인 범용밀링과 머시닝센터을 이용하여 재료를 가공하는 것을 평가하는 시험으로 고용노동부가 관장하고 한국산업인력공단에서 실시하는 국가 기술 자격증이다.',
'14,500원','36,300원','- 필기' || CHR(10) || '1. 도면해독' || CHR(10) || '2. 측정' || CHR(10) || '3. 밀링가공' || CHR(10) || ' - 실기' || CHR(10) || '컴퓨터응용밀링작업');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '로봇기구개발기사', '로봇의 기계 부분을 설계 및 개발 할 수 있는 자격증으로 2019년에 신설되었다. 전자공학, 기계공학 관련 학과 졸업(예정)자가 응시 가능하다. 기계공학 전공자가 유리한 편.',
'19,400원','45,000원',' - 필기' || CHR(10) || '1. 로봇기구사양설계' || CHR(10) || '2. 로봇기구설계' || CHR(10) || '3. 로봇기구해석' || CHR(10) || '4. 로봇통합 및 시험' || CHR(10) || '- 실기 ' || CHR(10) || '로봇기구개발 실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '전자기사', '한국산업인력공단에서 실시하는 전자계열 자격증. 1974년 전자기사 1급으로 신설, 1998년 전자기사로 명칭이 변경되었다.',
'19,400원','44,800원',' - 필기' || CHR(10) || '1. 전기자기학' || CHR(10) || '2. 디지털응용회로' || CHR(10) || '3. 전자회로설계' || CHR(10) || '4. 전자회로검증' || CHR(10) || '- 실기' || CHR(10) || '전자회로설계실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '의공기사', '의공기사는 한국산업인력공단에서 시행하는 국가기술자격 전자 분야의 기사 등급에 해당하는 자격증이며 최근 보건의료 산업과 제약 산업은 전 세계적으로 각광받는 최첨단 산업으로 촉망되고 있는 분야로, 국제적 수준의 인증과 품질 관리를 적용하기 위해서는 전문 기술 인력의 체계적인 양성이 필요하며, 이런 전문 인력의 수요는 앞으로 크게 증대될 것으로 예상되는 분야이다.',
'19,400원','22,600원',' - 필기' || CHR(10) || '1.의료기기 기초의학' || CHR(10) || '2. 의료기기 공학' || CHR(10) || '3. 의료기기 구조원리' || CHR(10) || '4. 의료기기 인허가' || CHR(10) || '5. 의료기기 관리' || CHR(10) || ' - 실기'|| CHR(10) ||  '의공 실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '전기기사', '한국산업인력공단에서 주관하는 전기분야 기사급 국가기술자격 시험. 1974년 전기기사1급으로 신설되고, 1998년 기사1급의 명칭이 기사로 바뀐 이래로 쭉 전기기사라는 이름으로 계속 시행되고 있다.',
'19,400원','22,600원','- 필기' || CHR(10) || '1. 전기자기학' || CHR(10) || '2. 전력공학' || CHR(10) || '3. 전기기기' || CHR(10) || '4. 회로이론 및 제어공학' || CHR(10) || '5. 전기설비기술기준' || CHR(10) || ' - 실기' || CHR(10) || '전기설비설계 및 관리');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '멀티미디어콘텐츠제작전문가', '과학기술정보통신부에서 주관하고 한국산업인력공단에서 관리하는 컴퓨터 관련 자격증으로 2002년에 신설되어 지금까지 명맥을 이어온 자격증이다. 시험은 보통 1년에 3번 실시한다.',
'19,400원','26,300원','- 필기' || CHR(10) || '1. 멀티미디어개론' || CHR(10) || '2. 멀티미디어 기획 및 디자인' || CHR(10) || '3. 멀티미디어 저작' || CHR(10) || '4. 멀티미디어 제작 기술' || CHR(10) || '- 실기' || CHR(10) || '멀티미디어콘텐츠제작 실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '광학기사', '광학기사는 한국산업인력공단에서 시행하는 국가기술자격 전자 분야의 기사 등급에 해당하는 자격증이다.' || CHR(10) || '광학을 이용한 기술은 안경, 확대경, 카메라, 복사기 등 일반적으로 쓰이는 광학기기외 에도 군사, 의료시술분야, 레이저응용분야. 광섬유분야. 광정보통신분야 등 매우 광범 위 하게 활용되고 있다.',
'19,400원','22,600원','- 필기' || CHR(10) || '1. 기하광학 및 광학기기' || CHR(10) || '2. 파동광학' || CHR(10) || '3. 광학계측과 광학평가' || CHR(10) || '4. 레이저 및 광전자' || CHR(10) || '- 실기' || CHR(10) || '광학실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '의공산업기사','의공산업기사는 한국산업인력공단에서 시행하는 국가기술자격 전자 분야의 산업기사 등급에 해당하는 자격증이다.' || CHR(10) || '의료기기 산업은 공학, 의학, 생물학, 재료학 등이 결합된 지식집약형 산업으로 인체의 생명과 안전성에 직접 영향을 주는 특징을 가지고 있으며, 미래의 경쟁에서 앞선 선진국의 기술 수준을 따라 잡기위해서는 의료기기 산업분야에서 종사하게 될 전문 기술인력을 확보하고자 자격제도 제정',
'19,400원','20,800원','- 필기' || CHR(10) || '1.의료기기 기초의학' || CHR(10) || '2. 의료기기 공학' || CHR(10) || '3. 의료기기 인허가' || CHR(10) || '4. 의료기기 유지보수' || CHR(10) || '- 실기' || CHR(10) || '의공 실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL, '전자산업기사','전자산업기사는 한국산업인력공단에서 시행하는 국가기술자격 전자 분야의 산업기사 등급에 해당하는 자격증이다.',
'19,400원','49,300원','- 필기' || CHR(10) || '1. 디지털응용회로' || CHR(10) || '2. 전자회로설계' || CHR(10) || '3. 전자회로구현설계' || CHR(10) || '4. 전자회로측정' || CHR(10) || '- 실기' || CHR(10) || '전자회로 구현 및 검증 실무');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'반도체설계산업기사','반도체설계산업기사는 한국산업인력공단에서 시행하는 국가기술자격 전자 분야의 산업기사 등급에 해당하는 자격증이다.' || CHR(10) || 'Back-end 설계 인력 양성의 전기를 마련하고, 산업체는 검증된 인력을 확보할 뿐만 아니라 재투자의 비용을 절감하는 전문인력의 양성이 필요하여 자격제도 제정',
'19,400원','27,800원','- 필기' || CHR(10) || '1. 반도체공학' || CHR(10) || '2. 전자회로' || CHR(10) || '3. 논리회로' || CHR(10) || '4. 집적회로 설계이론' || CHR(10) || '- 실기' || CHR(10) || '반도체설계 실무(직접회로 레이아웃 설계 및 검증)');
INSERT INTO LICENSE VALUES(LICENSE_SEQ.NEXTVAL,'사무자동화산업기사','과학기술정보통신부·산업통상자원부 공동 소관, 한국산업인력공단에서 시행하는 정보기술분야 산업기사 자격증의 일종.' || CHR(10) || '1993년 7월 사무정보기기응용기사 2급으로 신설, 1998년 5월 국가기술자격 체계 개편으로 사무자동화산업기사로 변경되어 현재에 이른다',
'19,400원','31,000원','- 필기' || CHR(10) || '1. 사무자동화시스템' || CHR(10) || '2. 사무경영관리개론' || CHR(10) || '3. 프로그래밍일반' || CHR(10) || '4. 정보통신개론' || CHR(10) || '- 실기' || CHR(10) || '사무자동화 실무');



INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'홍보/도배');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'음란물');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'불법');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'욕설');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'혐오발언');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'사칭');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'괴롭힘 및 따돌림');
INSERT INTO REPORT_TYPE VALUES(REPORT_TYPE_SEQ.NEXTVAL,'기타');


COMMIT;