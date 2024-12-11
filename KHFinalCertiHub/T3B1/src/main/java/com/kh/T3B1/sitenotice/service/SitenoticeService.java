package com.kh.T3B1.sitenotice.service;

import java.util.ArrayList;

import com.kh.T3B1.common.vo.PageInfo;
import com.kh.T3B1.common.vo.SearchOption;
import com.kh.T3B1.study.model.vo.StudyBoard;

public interface SitenoticeService {

	// 공지사항 개수 세기
	Integer countBoard(String keyword);

	// 공지사항 게시글 가져오기
	ArrayList<StudyBoard> selectBoardList(PageInfo pi, SearchOption so);

}
