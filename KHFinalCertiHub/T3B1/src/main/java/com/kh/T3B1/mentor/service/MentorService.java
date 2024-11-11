package com.kh.T3B1.mentor.service;

import java.util.ArrayList;

import com.kh.T3B1.common.vo.PageInfo;
import com.kh.T3B1.member.model.vo.Member;

public interface MentorService {

	// 전체 멘토수 조회
	int countMentor();
	
	// 멘토인 멤버 조회
	ArrayList<Member> selectMentorList(PageInfo pi);
	
}
