package com.kh.T3B1.community.model.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;

import com.kh.T3B1.common.vo.PageInfo;
import com.kh.T3B1.community.model.vo.Board;

public class CommunityDao {

	public int selectListCount(int certiNo, SqlSessionTemplate sqlSession) {
		return sqlSession.selectOne("boardMapper.selectListCount", certiNo);
	}

	public ArrayList<Board> selectList(SqlSessionTemplate sqlSession, PageInfo pi) {
//		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
//		
//		RowBounds rowBounds = new RowBounds(offset, pi.getBoardLimit());
//		return (ArrayList)sqlSession.selectList("boardMapper.selectList", null, rowBounds);
		return null;
	}

}
