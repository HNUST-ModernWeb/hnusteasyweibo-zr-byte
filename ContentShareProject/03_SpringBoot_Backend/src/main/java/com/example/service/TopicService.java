package com.example.service;

import com.example.entity.Topic;
import com.example.utils.Result;
import java.util.List;

public interface TopicService {
    Result<Topic> createTopic(Topic topic);
    Result<Topic> getTopicById(Long topicId);
    Result<Topic> getTopicByName(String name);
    Result<List<Topic>> getHotTopics(Integer limit);
    Result<List<Topic>> getRecommendTopics();
    Result<List<Topic>> getTopicsByCategory(String category);
    Result<List<Topic>> searchTopics(String keyword);
}
