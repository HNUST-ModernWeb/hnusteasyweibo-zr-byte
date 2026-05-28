package com.example.service.impl;

import com.example.entity.Topic;
import com.example.mapper.TopicMapper;
import com.example.service.TopicService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class TopicServiceImpl implements TopicService {

    @Autowired
    private TopicMapper topicMapper;

    @Override
    public Result<Topic> createTopic(Topic topic) {
        if (topicMapper.findByName(topic.getName()) != null) {
            return Result.fail("话题已存在");
        }
        topicMapper.insert(topic);
        return Result.success(topic);
    }

    @Override
    public Result<Topic> getTopicById(Long topicId) {
        Topic topic = topicMapper.findById(topicId);
        if (topic == null) {
            return Result.fail("话题不存在");
        }
        return Result.success(topic);
    }

    @Override
    public Result<Topic> getTopicByName(String name) {
        Topic topic = topicMapper.findByName(name);
        if (topic == null) {
            return Result.fail("话题不存在");
        }
        return Result.success(topic);
    }

    @Override
    public Result<List<Topic>> getHotTopics(Integer limit) {
        List<Topic> topics = topicMapper.findHotTopics(limit);
        return Result.success(topics);
    }

    @Override
    public Result<List<Topic>> getRecommendTopics() {
        List<Topic> topics = topicMapper.findRecommendTopics();
        return Result.success(topics);
    }

    @Override
    public Result<List<Topic>> getTopicsByCategory(String category) {
        List<Topic> topics = topicMapper.findByCategory(category);
        return Result.success(topics);
    }

    @Override
    public Result<List<Topic>> searchTopics(String keyword) {
        List<Topic> topics = topicMapper.searchTopics(keyword);
        return Result.success(topics);
    }
}
